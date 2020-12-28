class Validator
  class << self
    def validate(username, password)
      @errors = []
      validate_username(username)
      validate_password(password)
      @errors
    end

    def validate_username(username)
      @errors << 'User already exists' if redis.get(username)
    end

    def validate_password(password)
      @errors << 'Password length too small' if password.length < 6
    end

    def redis
      Redis.new(host: 'redis', port: 6379)
    end
  end
end
