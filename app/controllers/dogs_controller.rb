class DogsController < ApplicationController
  before_action :set_dog, only: [:feed, :stroke, :play, :update_state]
  skip_before_action :require_login

  def feed
    @dog.satiety += 50
    @dog.satiety = [@dog.satiety, @dog.max_satiety].min
    @dog.save
    render json: @dog
  end

  def stroke
    @dog.happiness += 50
    @dog.happiness = [@dog.happiness, @dog.max_happiness].min
    @dog.save
    render json: @dog
  end

  def play
    @dog.gain_experience(15)
    @dog.physical -= 3
    @dog.satiety = [@dog.satiety, 0].max
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