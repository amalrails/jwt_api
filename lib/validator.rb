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
      @errors << 'Password has no digits' if password[/\d/].nil?
      @errors << 'Password has no lowercase character' if password[/[A-Z]/].nil?
      @errors << 'Password has no uppercase character' if password[/[a-z]/].nil?
    end

    def redis
      host = Rails.env.test? ? 'localhost' : 'redis'
      Redis.new(host: host, port: 6379)
    end
  end
end
