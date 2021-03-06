require('api_constraints')
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
        get '/policy_rules', to: 'users#generate_policy_rules'
      end
      post 'auth', to: 'authentication#authenticate'
      resources :sessions, :only => [:create, :destroy]
      resources :devices, :only => [:show, :index, :create, :update] do
        post '/gcm_token', to: 'gcm_tokens#create'
        patch '/gcm_token', to: 'gcm_tokens#update'
        put '/gcm_token', to: 'gcm_tokens#update'
      end
      resources :applications, :only => [:show, :index, :create], constraints: { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
        get '/:version', to: 'applications#download_version_apk', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
        get '/:version/resources/:file_name', to: 'applications#show_version_res_file', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/,
                                                                                :file_name => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
        get '/resources/:file_name', to: 'applications#show_res_file', constraints: { :file_name => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ }
        put '/:version/status', to: 'applications#edit_status', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
        patch '/:version/status', to: 'applications#edit_status', constraints: { :version => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/}
      end
      resources :user_groups, :only => [:show, :index, :create, :update] do
        get '/members', to: 'user_groups#show_members'
        post '/members/:usernames', to: 'user_groups#add_members'
        delete '/members/:usernames', to: 'user_groups#remove_members'
      end

      resources :policies, only: [:show, :index] do
        resources :rules, only: [:index, :create, :destroy]
        delete '/rules', to: 'rules#bulk_destroy'
      end

      resources :rules, only: [:index, :create, :update ,:destroy] do
        get '/entities', to: 'rules#show_entities'
        post '/entities/:entity_ids', to: 'rules#add_entities'
        delete '/entities/:entity_ids', to: 'rules#remove_entities'
      end

      resources :device_sessions, only: [:create, :destroy]

      resources :installations, only: [:create, :update]
    end
  end
end
