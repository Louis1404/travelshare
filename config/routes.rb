Rails.application.routes.draw do
  devise_for :users, except: [:destroy]
  get '/users/sign_out', to: 'devise/sessions#destroy'
  root to: 'pages#home'
  resources :trips, except: [:create]
  get '/dashboard', to: 'accounts#dashboard'
  get '/add_travellers', to: 'trips#add_travellers'
  get '/delete_travellers', to: 'trips#delete_travellers'
  get '/search', to: 'trips#create'
  resources :profiles, only: [:edit]
  get '/profile', to: 'devise/registrations#edit', as: 'profile'
  get '/getinfos', to: 'trips#find_traveller_trip'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
