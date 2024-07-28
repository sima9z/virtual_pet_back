class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]
  
  def create
    user = User.new(user_params)
    if user.save
      render json: { user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def current_user_action
    if logged_in?
      render json: current_user, only: [:id, :email, :name]
    else
      render json: { message: "Not logged in" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
