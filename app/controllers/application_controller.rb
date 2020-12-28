class ApplicationController < ActionController::API
  require 'json_web_token'
  require 'redis'

  protected

  # Validates the token and user and sets the @current_user scope
  def authenticate_user!
    invalid_authentication if !payload || !JsonWebToken.valid_payload(payload.first)
  end

  def authenticate_request!
    api_key = request.headers['HTTP_API_KEY']
    return if Figaro.env.api_key.eql?(api_key)

    render json: { error: 'Unauthorized Request' }, status: :unauthorized
  end

  # Returns 401 response. To handle malformed / invalid requests.
  def invalid_authentication
    render json: { error: 'Unauthorized Request' }, status: :unauthorized
  end

  private

  # Deconstructs the Authorization header and decodes the JWT token.
  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  rescue JWT::DecodeError, StandardError
    false
  end
end
