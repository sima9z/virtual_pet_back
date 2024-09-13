class CatsController < ApplicationController
  before_action :set_cat, only: [:feed, :stroke, :play, :update_state]
  skip_before_action :require_login

  def feed
    if !@cat.can_feed?
      cooldown_remaining = (COOLDOWN_TIME - (Time.current - @cat.last_feed_at)).to_i
      render json: { error: "まだご飯をあげたばかりです。あと #{cooldown_remaining / 60} 分待ってください。" }, status: :unprocessable_entity
      return
    end

    @cat.satiety += 50
    @cat.satiety = [@cat.satiety, @cat.max_satiety].min
    @cat.last_feed_at = Time.current # 最後にご飯をあげた時間を記録
    @cat.update_states

    @cat.save
    render json: @cat
  end

  def stroke
    if !@cat.can_stroke?
      cooldown_remaining = (COOLDOWN_TIME - (Time.current - @cat.last_stroke_at)).to_i
      render json: { error: "あまりかまうとストレスになります。あと #{cooldown_remaining / 60} 分待ってください。" }, status: :unprocessable_entity
      return
    end

    @cat.happiness += 50
    @cat.happiness = [@cat.happiness, @cat.max_happiness].min
    @cat.last_stroke_at = Time.current # 最後になでた時間
    @cat.update_states

    @cat.save
    render json: @cat
  end

  def play
    if @cat.physical < 3
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

    @cat.gain_experience(15)
    @cat.physical -= 3
    @cat.physical = [@cat.physical, 0].max
    if @cat.save
      render json: @cat
    else
      render json: { errors: @cat.errors }, status: :unprocessable_entity
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

  private

  def set_cat
    @cat = current_user.cat
  end

  def cat_params
    params.require(:cat).permit(:name, :breed, :experience, :level, :states)
  end
end