Rails.application.routes.draw do
  namespace :api do
    post 'users/login'
    post 'users/create'
  end
end
