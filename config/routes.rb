Rails.application.routes.draw do
  
  root 'welcome#landing_page'

  resources :users, only: [:new, :create]
  get 'ui(/:action)', controller: 'ui'
  post '/login', to: 'sessions#create', as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  resources :forgot_passwords, only: [:create]
  get '/forgot_passwords', to: "forgot_passwords#new", as: 'new_password'
  get '/forgot_passwords_confirmation', to: "forgot_passwords#confirmation", as: 'forgot_passwords_confirmation'
  
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'password_resets#expired_token'


  resources :groups, only: [:index, :create] do
    resources :posts, only: [:index, :create]
    resources :guides, only: [:index, :show, :create]
  end
end
