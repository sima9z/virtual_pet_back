class UserSessionsController < ApplicationController
  skip_before_action :require_login

  def create
    user = login(params[:email], params[:password])
    if user
      Rails.logger.debug "Logged in user: #{user.inspect}"
      Rails.logger.debug "Session ID: #{session[:user_id]}"
      session[:user_id] = user.id
      render json: { user: user }, status: :ok
    else
      Rails.logger.debug "Invalid email or password for email: #{params[:email]}"
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    Rails.logger.debug "Current user before logout: #{current_user.inspect}"
    logout
    cookies.delete(:remember_token, domain: :all)
    Rails.logger.debug "Current user after logout: #{current_user.inspect}"
    render json: { message: 'Logged out' }, status: :ok
  end

end