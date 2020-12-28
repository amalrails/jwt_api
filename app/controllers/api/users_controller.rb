class Api::UsersController < ApplicationController
  require 'redis_service'

  before_action :authenticate_request!, only: %i[create login]
  before_action :authenticate_user!, except: %i[create login]

  def login
    encrypted_user_password = RedisService.get_user(user_params[:username])

    if encrypted_user_password && BCrypt::Password.new(encrypted_user_password) == (user_params[:password])
      # auth_token here is JWT that can be used for further api calls post login
      auth_token = JsonWebToken.encode(username: user_params[:username])
      render json: { message: 'Authentication Successful', auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username/password' }, status: :unauthorized
    end
  end

  def create
    response = RedisService.add_user(user_params[:username], user_params[:password])
    if response.eql?('OK')
      # auth_token here is JWT that can be used for further api calls post login
      auth_token = JsonWebToken.encode(username: user_params[:username])
      render json: { message: 'User created!!', auth_token: auth_token }, status: :ok
    else
      render json: { errors: response.join(',') }, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
