require('api_constraints');
Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do
    scope module: :v1,
        constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
      resources :users, :only => [:show, :create] do
        resource :devices, only: [:show]
        post '/devices/:imeis', to: 'users#assign_devices'
        delete '/devices/:imeis', to: 'users#remove_device_assignations'
      end
      resources :sessions, :only => [:create, :destroy]
      resources :devices, :only => [:show, :index, :create, :update]
    end
  end
end
