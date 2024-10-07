class CatsController < ApplicationController
  before_action :set_cat, only: [:feed, :stroke, :play, :update_state, :update]
  skip_before_action :require_login

  def feed
    if !@cat.can_feed?
      cooldown_remaining = (Cat::COOLDOWN_TIME - (Time.current - @cat.last_feed_at)).to_i
      render json: { error: "まだご飯をあげたばかりです。あと #{cooldown_remaining / 60} 分待ってください。" }, status: :unprocessable_entity
      return
    end

    @cat.satiety += 100
    @cat.satiety = [@cat.satiety, @cat.max_satiety].min
    @cat.last_feed_at = Time.current # 最後にご飯をあげた時間を記録
    @cat.update_states

    @cat.save
    render json: @cat
  end

  def stroke
    if !@cat.can_stroke?
      cooldown_remaining = (Cat::COOLDOWN_TIME - (Time.current - @cat.last_stroke_at)).to_i
      render json: { error: "あまりかまうとストレスになります。あと #{cooldown_remaining / 60} 分待ってください。" }, status: :unprocessable_entity
      return
    end

    @cat.happiness += 100
    @cat.happiness = [@cat.happiness, @cat.max_happiness].min
    @cat.last_stroke_at = Time.current # 最後になでた時間
    @cat.update_states

    @cat.save
    render json: @cat
  end

  def play
    if @cat.physical < 10
      render json: { error: '疲れているようです。休ませてあげましょう' }, status: :unprocessable_entity
      return
    end

    if @cat.states == 1
      render json: { error: 'お腹がすいているようです。先にご飯を上げてください' }, status: :unprocessable_entity
      return
    end

    if @cat.states == 2
      render json: { error: 'なんだが不機嫌そうで遊んでくれません。' }, status: :unprocessable_entity
      return
    end

    if @cat.states == 3
      render json: { error: 'お腹もすいているようですし、なんだか寂しそうです' }, status: :unprocessable_entity
      return
    end

    # 日をまたいだらフラグとプレイカウントをリセット
    if @cat.last_played_at.present? && @cat.last_played_at.to_date != Date.current
      @cat.bad_status_flag = false
      @cat.play_count = 0
    end

    if @cat.bad_status_flag
      if @cat.play_count >= 3
        render json: { error: '今日はもう十分遊びました。また明日遊びましょう。' }, status: :unprocessable_entity
        return
      end
    end

    previous_level = @cat.level
    previous_offspring_born = @cat.offspring_count

    # 獲得経験値をレベルに応じて動的に計算
    base_experience = 50
    experience_gain = base_experience * Math.sqrt(@cat.level) # レベルに応じた経験値を計算
    @cat.gain_experience(experience_gain)

    @cat.physical -= 10
    @cat.physical = [@cat.physical, 0].max

    # 遊び回数のカウントと最終遊び日時の更新
    @cat.play_count += 1
    @cat.last_played_at = Time.current

    # レベルアップと繁殖のフラグを設定
    level_up = @cat.level > previous_level
    offspring_born = @cat.offspring_count > previous_offspring_born

    if @cat.save
      render json: { cat: @cat, level_up: level_up, offspring_born: offspring_born, success: true }
    else
      render json: { errors: @cat.errors, success: false }, status: :unprocessable_entity
    end
  end

  def create
    @cat = current_user.build_cat(cat_params)
    if @cat.save
      render json: @cat, status: :created
    else
      render json: @cat.errors, status: :unprocessable_entity
    end
  end

  def update
    if @cat.update(cat_params)
      render json: @cat, status: :ok
    else
      render json: @cat.errors, status: :unprocessable_entity
    end
  end

  private

  def set_cat
    @cat = current_user.cat
  end

  def cat_params
    params.require(:cat).permit(:name, :breed)
  end

end