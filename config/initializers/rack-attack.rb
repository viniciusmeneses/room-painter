require_relative "redis"

Rack::Attack.enabled = true
Rack::Attack.cache.store = REDIS
Rack::Attack.throttle("Rate limit by IP", limit: 10, period: 10.seconds, &:ip)
