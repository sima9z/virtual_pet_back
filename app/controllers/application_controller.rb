class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # CSRFトークンの検証をスキップ
  skip_before_action :verify_authenticity_token

end
