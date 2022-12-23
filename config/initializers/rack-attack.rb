Rack::Attack.enabled = true
Rack::Attack.cache.store = Redis.new(url: ENV["REDIS_URL"])
Rack::Attack.throttle("Rate limit by IP", limit: 10, period: 10.seconds, &:ip)
