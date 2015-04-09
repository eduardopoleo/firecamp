Rails.application.routes.draw do
  
  root 'welcome#landing_page'

  resources :users, only: [:new, :create]
  get '/invited_user/:token', to: 'users#invited_user', as: 'invited_user'
  post '/create_invited_user', to: 'users#create_invited_user', as: 'create_invited_user'

  get 'ui(/:action)', controller: 'ui'
  post '/login', to: 'sessions#create', as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  resources :forgot_passwords, only: [:create]
  get '/forgot_passwords', to: "forgot_passwords#new", as: 'new_password'
  get '/forgot_passwords_confirmation', to: "forgot_passwords#confirmation", as: 'forgot_passwords_confirmation'
  
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'password_resets#expired_token'

  resources :groups, only: [:index, :create]
  resources :posts, only: [:create]
  get 'group_posts/:group_id', to: 'groups#group_posts', as: 'group_posts'
  get 'group_guides/:group_id', to: 'groups#group_guides', as: 'group_guides'

  resources :guides, only: [:show, :create]

  resources :invitations, only: [:new, :create]
  get '/expired_invitation', to: 'invitations#expired_invitation', as: 'expired_invitation'
end
