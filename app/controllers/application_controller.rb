class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # CSRFトークンの検証をスキップ
  skip_before_action :verify_authenticity_token

  before_action :set_cors_headers

  private

  def set_cors_headers
    response.set_header('Access-Control-Allow-Origin', 'https://virtual-pet-front.vercel.app')
    response.set_header('Access-Control-Allow-Credentials', 'true')
    response.set_header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD')
    response.set_header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept, Authorization, Token')
  end
end
