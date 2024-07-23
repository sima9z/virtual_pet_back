Rails.application.config.session_store :redis_store, servers: [
  {
    host: "redis", # Docker Composeのサービス名
    port: 6379,
    db: 0,
    namespace: "session"
  },
], expire_after: 90.minutes, key: "_#{Rails.application.class.module_parent_name.downcase}_session"