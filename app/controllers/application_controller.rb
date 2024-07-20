class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # CSRFトークンをヘッダーに含める
  after_action :set_csrf_cookie

  def csrf_token
    render json: { csrfToken: form_authenticity_token }
  end

  private

  def set_csrf_cookie
    Rails.logger.debug "CSRF Token generated: #{form_authenticity_token}"
    cookies['CSRF-TOKEN'] = {
      value: form_authenticity_token,
      secure: Rails.env.production?,
      same_site: :none
    } if protect_against_forgery?
  end

  protected

  def verified_request?
    super || valid_csrf_token?
  end

  def valid_csrf_token?
    token = request.headers['X-CSRF-Token']
    Rails.logger.debug "CSRF Token from request: #{token}"
    Rails.logger.debug "CSRF Token from session: #{session[:_csrf_token]}"
    token.present? && (token == form_authenticity_token || token == session[:_csrf_token])
  end
end
