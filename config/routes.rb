require('api_constraints');
Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do
    scope module: :v1,
        constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our files here
      resources :users, :only => [:show, :create] do
        get '/devices', to: 'users#show_devices'
        post '/devices/:imeis', to: 'users#assign_devices'
        delete '/devices/:imeis', to: 'users#remove_device_assignations'
      end
      resources :sessions, :only => [:create, :destroy]
      resources :devices, :only => [:show, :index, :create, :update]
      resources :applications, :only => [:show, :index, :create], constraints: { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
        get '/:version?d', to: 'applications#download_version_apk', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
        get '/:version/resources/:file_name', to: 'applications#show_version_file', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/,
                                                                                :file_name => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
        get '/resources/:file_name', to: 'applications#show_res_file', constraints: { :file_name => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ }
      end
    end
  end
end
