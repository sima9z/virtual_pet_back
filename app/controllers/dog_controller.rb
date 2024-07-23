class DogController < ApplicationController
  skip_before_action :require_login
  before_action :set_dog, only: [:feed, :water, :walk, :update_state]

  def feed
    @dog.gain_experience(10)
    render json: @dog
  end

  def water
    @dog.gain_experience(5)
    render json: @dog
  end

  def walk
    @dog.gain_experience(15)
    render json: @dog
  end

  def update_state
    hungry_amount = params[:hungry]
    thirsty_amount = params[:thirsty]
    @dog.update_state(hungry_amount, thirsty_amount)
    render json: @dog
  end

  def create
    @dog = current_user.dog.build(dog_params)
    if @dog.save
      render json: @dog, status: :created
    else
      render json: @dog.errors, status: :unprocessable_entity
    end
  end

  private

  def set_dog
    @dog = current_user.dog.find(params[:id])
  end

  def dog_params
    params.require(:dog).permit(:name, :breed, :age, :experience, :level, :hungry, :thirsty, :is_adult)
  end
end