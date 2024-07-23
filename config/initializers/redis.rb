$redis = Redis.new(url: ENV['REDIS_URL'])

# ログ出力で接続確認
Rails.logger.debug "Redis URL: #{ENV['REDIS_URL']}"