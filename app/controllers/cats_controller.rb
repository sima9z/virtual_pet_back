class CatsController < ApplicationController
  before_action :set_cat, only: [:feed, :stroke, :play, :update_state]
  skip_before_action :require_login

  def feed
    @cat.gain_experience(10)
    render json: @cat
  end

  def stroke
    @cat.gain_experience(5)
    render json: @cat
  end

  def play
    @cat.gain_experience(15)
    @cat.physical -= 3
    if @cat.save
      render json: @cat
    else
      render json: { errors: @cat.errors }, status: :unprocessable_entity
    end
  end

  def update_state
    hungry_amount = params[:hungry]
    thirsty_amount = params[:thirsty]
    @cat.update_state(hungry_amount, thirsty_amount)
    render json: @cat
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