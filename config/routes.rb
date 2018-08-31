Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :trips, except: [:create]
  get '/dashboard', to: 'accounts#dashboard'
  get '/profile', to: 'profile#edit'
  get '/add_travellers', to: 'trips#add_travellers'
  get '/delete_travellers', to: 'trips#delete_travellers'
  get '/search', to: 'trips#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
