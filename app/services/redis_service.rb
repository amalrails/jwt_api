class RedisService
  require 'validator'

  class << self
    def add_user(username, password)
      errors = Validator.validate(username, password)
      if errors.empty?
        encrypted_password = BCrypt::Password.create(password)
        redis.set(username, encrypted_password)
      else
        errors
      end
    end

    def get_user(username)
      redis.get(username)
    end

    def redis
      host = Rails.env.test? ? 'localhost' : 'redis'
      Redis.new(host: host, port: 6379)
    end
  end
end
