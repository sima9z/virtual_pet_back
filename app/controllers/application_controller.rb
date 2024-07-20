class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # CSRFトークンをヘッダーに含める
  after_action :set_csrf_cookie

  def csrf_token
    render json: { csrfToken: form_authenticity_token }
  end

  private

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = {
      value: form_authenticity_token,
      secure: Rails.env.production?,
      same_site: :strict
    } if protect_against_forgery?
  end

  protected

  def verified_request?
    super || valid_csrf_token?
  end

  def valid_csrf_token?
    request.headers['X-CSRF-Token'] == form_authenticity_token ||
      request.headers['X-CSRF-Token'] == session[:_csrf_token]
  end
end
