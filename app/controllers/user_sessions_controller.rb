class UserSessionsController < ApplicationController
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