class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  
  protect_from_forgery with: :exception

  before_action :require_login, except: [:csrf_token] # csrf_tokenアクションを除外

  # CSRFトークンをヘッダーに含める
  after_action :set_csrf_cookie

  def csrf_token
    set_csrf_cookie
    Rails.logger.debug "Generated CSRF Token: #{@csrf_token}"
    render json: { csrfToken: @csrf_token }
  end

  def not_authenticated
    render json: { message: "Please login first" }, status: :unauthorized
  end

  private

  def set_csrf_cookie
    @csrf_token ||= form_authenticity_token
    cookies['CSRF-TOKEN'] = {
      value: @csrf_token,
      secure: Rails.env.production?,
      same_site: :none
    } if protect_against_forgery?
    response.headers['X-CSRF-Token'] = @csrf_token
    Rails.logger.debug "Set CSRF Token in cookie and header: #{@csrf_token}"
  end

  protected

  def verified_request?
    super || valid_csrf_token?
  end

  def valid_csrf_token?
    token = request.headers['X-CSRF-Token']
    Rails.logger.debug "CSRF Token from request: #{token}"
    Rails.logger.debug "CSRF Token from session: #{session[:_csrf_token]}"
    token.present? && (token == session[:_csrf_token])
  end

end
