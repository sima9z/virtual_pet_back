class DogsController < ApplicationController
  before_action :set_dog, only: [:feed, :stroke, :play, :update_state, :update]
  skip_before_action :require_login

  def feed
    if !@dog.can_feed?
      cooldown_remaining = (Dog::COOLDOWN_TIME - (Time.current - @dog.last_feed_at)).to_i
      render json: { error: "まだご飯をあげたばかりです。あと #{cooldown_remaining / 60} 分待ってください。" }, status: :unprocessable_entity
      return
    end

    @dog.satiety += 50
    @dog.satiety = [@dog.satiety, @dog.max_satiety].min
    @dog.last_feed_at = Time.current # 最後にご飯をあげた時間を記録
    @dog.update_states

    @dog.save
    render json: @dog
  end

  def stroke
    if !@dog.can_stroke?
      cooldown_remaining = (Dog::COOLDOWN_TIME - (Time.current - @dog.last_stroke_at)).to_i
      render json: { error: "あまりかまうとストレスになります。あと #{cooldown_remaining / 60} 分待ってください。"}, status: :unprocessable_entity
      return
    end

    @dog.happiness += 50
    @dog.happiness = [@dog.happiness, @dog.max_happiness].min
    @dog.last_stroke_at = Time.current # 最後になでた時間
    @dog.update_states

    @dog.save
    render json: @dog
  end

  def play
    if @dog.physical < 3
      render json: { error: '疲れているようです。休ませてあげましょう' }, status: :unprocessable_entity
      return
    end

    if @dog.states == 1
      render json: { error: 'お腹がすいているようです。先にご飯を上げてください' }, status: :unprocessable_entity
      return
    end

    if @dog.states == 2
      render json: { error: 'なんだが不機嫌そうで遊んでくれません。' }, status: :unprocessable_entity
      return
    end

    if @dog.states == 3
      render json: { error: 'お腹もすいているようですし、なんだか寂しそうです' }, status: :unprocessable_entity
      return
    end

    # 日をまたいだらフラグとプレイカウントをリセット
    if @dog.last_played_at.present? && @dog.last_played_at.to_date != Date.current
      @dog.bad_status_flag = false
      @dog.play_count = 0
    end

    if @dog.bad_status_flag
      if @dog.play_count >= 3
        render json: { error: '今日はもう十分遊びました。また明日遊びましょう。' }, status: :unprocessable_entity
        return
      end
    end

    previous_level = @dog.level
    @dog.gain_experience(15)
    @dog.physical -= 3
    @dog.physical = [@dog.physical, 0].max

    # 遊び回数のカウントと最終遊び日時の更新
    @dog.play_count += 1
    @dog.last_played_at = Time.current

    # レベルアップと繁殖のフラグを設定
    level_up = @dog.level > previous_level
    offspring_born = @dog.offspring_count > 0 && @dog.level % 3 == 0

    if @dog.save
      render json: { dog: @dog, level_up: level_up, offspring_born: offspring_born, success: true }
    else
      render json: { errors: @dog.errors, success: false }, status: :unprocessable_entity
    end
  end

  def create
    if current_user.dog.present?
      render json: { error: 'すでにペットが存在します。更新を行ってください。' }, status: :unprocessable_entity
    else
      @dog = current_user.build_dog(dog_params)
      if @dog.save
        render json: @dog, status: :created
      else
        render json: @dog.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @dog.update(dog_params)
      render json: @dog, status: :ok
    else
      render json: @dog.errors, status: :unprocessable_entity
    end
  end

  private

  def set_dog
    @dog = current_user.dog
  end

  def dog_params
    params.require(:dog).permit(:name, :breed)
  end

end