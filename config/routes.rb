Rails.application.routes.draw do
  devise_for :views
  devise_for :users
  root to: 'pages#home'
  resources :trips
  get '/dashboard', to: 'accounts#dashboard'
  get '/profile', to: 'profile#edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
