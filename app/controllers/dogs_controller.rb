class DogsController < ApplicationController
  before_action :set_dog, only: [:feed, :water, :play, :update_state]
  skip_before_action :require_login

  def feed
    @dog.gain_experience(10)
    render json: @dog
  end

  def water
    @dog.gain_experience(5)
    render json: @dog
  end

  def play
    @dog.gain_experience(15)
    @dog.physical -= 3
    if @dog.save
      render json: @dog
    else
      render json: { errors: @dog.errors }, status: :unprocessable_entity
    end
  end

  def update_state
    hungry_amount = params[:hungry]
    thirsty_amount = params[:thirsty]
    @dog.update_state(hungry_amount, thirsty_amount)
    render json: @dog
  end

  def create
    @dog = current_user.build_dog(dog_params)
    if @dog.save
      render json: @dog, status: :created
    else
      render json: @dog.errors, status: :unprocessable_entity
    end
  end

  private

  def set_dog
    @dog = current_user.dog
  end

  def dog_params
    params.require(:dog).permit(:name, :breed, :experience, :level, :states)
  end
end