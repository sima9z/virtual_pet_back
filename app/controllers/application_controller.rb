class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception

  def csrf_token
    render json: { csrfToken: form_authenticity_token }
  end

  protected

  def verified_request?
    valid_request = super || valid_csrf_token?
    Rails.logger.debug "Verified request: #{valid_request}"
    valid_request
  end

  def valid_csrf_token?
    token = request.headers['X-CSRF-Token']
    session_token = session[:_csrf_token]
    form_token = form_authenticity_token
    Rails.logger.debug "CSRF Token from request: #{token}"
    Rails.logger.debug "CSRF Token from session: #{session_token}"
    Rails.logger.debug "Form authenticity token: #{form_token}"
    token_present = token.present?
    Rails.logger.debug "Token present: #{token_present}"
    compare_form_token = ActiveSupport::SecurityUtils.secure_compare(token.to_s, form_token.to_s)
    Rails.logger.debug "Token matches form token: #{compare_form_token}"
    compare_session_token = ActiveSupport::SecurityUtils.secure_compare(token.to_s, session_token.to_s)
    Rails.logger.debug "Token matches session token: #{compare_session_token}"

    token_present && (compare_form_token || compare_session_token)
  end
end