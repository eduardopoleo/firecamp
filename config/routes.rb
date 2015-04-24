Rails.application.routes.draw do
  
  root 'welcome#landing_page'

  resources :users, except: [:destroy, :index]

  resources :groups do
    resources :users, only: [:index]
    
    resources :posts, only: [:index, :create] do
      member do
        post 'vote', to: 'posts#vote'
      end
    end

    resources :guides, only: [:index, :create, :show]
  end

  get 'ui(/:action)', controller: 'ui'
  post '/login', to: 'sessions#create', as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  resources :forgot_passwords, only: [:create]
  get '/forgot_passwords', to: "forgot_passwords#new", as: 'new_password'
  get '/forgot_passwords_confirmation', to: "forgot_passwords#confirmation", as: 'forgot_passwords_confirmation'
  
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:new, :create]
  get '/expired_invitation', to: 'invitations#expired_invitation', as: 'expired_invitation'
  get '/invited_user/:token', to: 'users#invited_user', as: 'invited_user'
  post '/create_invited_user', to: 'users#create_invited_user', as: 'create_invited_user'
end
