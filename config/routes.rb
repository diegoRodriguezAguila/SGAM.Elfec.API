require('api_constraints');
Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do
    scope module: :v1,
        constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our files here
      resources :users, :only => [:show, :index, :create] do
        get '/devices', to: 'users#show_devices'
        post '/devices/:imeis', to: 'users#assign_devices'
        delete '/devices/:imeis', to: 'users#remove_device_assignations'
        get '/resources/:file_name', to: 'users#show_res_file', constraints: { :file_name => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ }
      end
      resources :sessions, :only => [:create, :destroy]
      resources :devices, :only => [:show, :index, :create, :update]
      resources :applications, :only => [:show, :index, :create], constraints: { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
        get '/:version', to: 'applications#download_version_apk', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
        get '/:version/resources/:file_name', to: 'applications#show_version_res_file', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/,
                                                                                :file_name => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
        get '/resources/:file_name', to: 'applications#show_res_file', constraints: { :file_name => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ }
      end
      resources :user_groups, :only => [:show, :index, :create, :update] do
        get '/members', to: 'user_groups#show_members'
        post '/members/:usernames', to: 'user_groups#add_members'
        delete '/members/:usernames', to: 'user_groups#remove_members'
      end

      resources :policies, only: [:show, :index] do
        get '/rules', to: 'policies#show_rules'
        post '/rules', to: 'policies#add_rule'
        delete '/rules/:rule_id', to: 'policies#delete_rule'
      end
    end
  end
end
