Rails.application.routes.draw do
  
  root 'welcome#landing_page'

  resources :users, only: [:new, :create] do
    member do
      get '/dashboard', to: 'users#dashboard'
    end
  end

  get 'ui(/:action)', controller: 'ui'

  post '/login', to: 'sessions#create', as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  get '/forgot_passwords', to: "forgot_passwords#new", as: 'new_password'
  get '/forgot_passwords_confirmation', to: "forgot_passwords#confirmation", as: 'forgot_passwords_confirmation'
  resources :forgot_passwords, only: [:create]

  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'password_resets#expired_token'
end
