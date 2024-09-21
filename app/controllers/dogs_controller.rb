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

    @dog.gain_experience(15)
    @dog.physical -= 3
    @dog.physical = [@dog.physical, 0].max
    if @dog.save
      render json: @dog
    else
      render json: { errors: @dog.errors }, status: :unprocessable_entity
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