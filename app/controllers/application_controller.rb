class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # CSRFトークンをヘッダーに含める
  after_action :set_csrf_cookie

  def csrf_token
    render json: { csrfToken: form_authenticity_token }
  end

  private

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-CSRF-Token']
  end

end
