class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  
  protect_from_forgery with: :exception

  before_action :require_login

  # CSRFトークンの検証をスキップ
  skip_before_action :verify_authenticity_token

  def not_authenticated
    render json: { message: "Please login first" }, status: :unauthorized
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
      @current_user = nil
    end
  end

  def logged_in?
    !current_user.nil?
  end

end
