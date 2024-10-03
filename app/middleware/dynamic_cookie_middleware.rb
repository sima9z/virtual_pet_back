class DynamicCookieMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    
    # モバイル端末やSafariの場合に same_site を :lax に設定
    if request.user_agent =~ /Mobile|Safari/
      Rails.application.config.session_options[:same_site] = :lax
    else
      Rails.application.config.session_options[:same_site] = ENV['SESSION_SAME_SITE']&.to_sym || :lax
    end

    @app.call(env)
  end
end