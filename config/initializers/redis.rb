#REDIS = Redis::Namespace.new("price_alert_app", :redis => Redis.new)
REDIS = Redis.new(host: 'localhost', port: 6379, db: "price_alert_app")