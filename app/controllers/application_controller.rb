class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # CSRFトークンを生成して返すエンドポイント
  def csrf_token
    Rails.logger.debug "Session ID (csrf_token): #{session.id}"
    Rails.logger.debug "CSRF Token (csrf_token): #{form_authenticity_token}"
    render json: { csrfToken: form_authenticity_token }
  end

  protected

  def verified_request?
    super || valid_csrf_token?
  end

  def valid_csrf_token?
    token = request.headers['X-CSRF-Token']
    session_token = session[:_csrf_token]
    Rails.logger.debug "CSRF Token from request: #{token}"
    Rails.logger.debug "Session ID (valid_csrf_token): #{session.id}"
    Rails.logger.debug "CSRF Token from session: #{session_token}"
    ActiveSupport::SecurityUtils.secure_compare(token.to_s, form_authenticity_token.to_s) ||
      ActiveSupport::SecurityUtils.secure_compare(token.to_s, session_token.to_s)
  end
end