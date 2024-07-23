class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]
  
  def create
    user = login(params[:email], params[:password])
    if user
      render json: { user: user }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    logout
    render json: { message: 'Logged out' }, status: :ok
  end

end