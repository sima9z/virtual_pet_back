class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception

  before_action :require_login

  # CSRFトークンの検証をスキップ
  skip_before_action :verify_authenticity_token

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to login_path, alert: "Please login first" }
      format.json { render json: { message: "Please login first" }, status: :unauthorized }
    end
  end

end
