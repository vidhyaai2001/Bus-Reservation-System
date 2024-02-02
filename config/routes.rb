Rails.application.routes.draw do
  #resources :buses
  resources :buses do
    resources :reservations
     collection do
      get 'search'  # This creates a route like /buses/search
    end
  end
  #resources :reservations
  get 'your_buses' => 'bus_owners#index'
 # devise_for :users
 # config/routes.rb
devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
resources :customers

get 'my_resevations' => 'customers#my_resevations'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "buses#index"
end