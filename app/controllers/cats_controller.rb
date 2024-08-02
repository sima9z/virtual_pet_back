class CatsController < ApplicationController
  before_action :set_cat, only: [:feed, :water, :walk, :update_state]

  def feed
    @cat.gain_experience(10)
    render json: @cat
  end

  def water
    @cat.gain_experience(5)
    render json: @cat
  end

  def walk
    @cat.gain_experience(15)
    render json: @cat
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
    params.require(:cat).permit(:name, :breed, :age, :experience, :level, :states, :is_adult)
  end
end