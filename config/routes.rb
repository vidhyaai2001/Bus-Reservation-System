Rails.application.routes.draw do
  # resources :buses do
  #   resources :reservations do
  #     collection do 
  #       get  'my_reservations'
  #     end
  #   end
  #    collection do
  #     get 'search'  
  #   end
  # end
  # resources :bus_owners do
  #   collection do
  #     get 'search' 
  #   end
  # end
  # #get 'your_buses' => 'bus_owners#index'
  # get 'my_reservations' => 'customers#my_reservations'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }

   
  namespace :owner do
    resources :buses do 
      collection do
        get 'search'  
       end
      resources :reservations
    end
  end

  #resources :buses, only: [:index] do
  resources :buses do 
    resources :reservations,only: [:new,:create,:destroy]
    collection do
     get 'search'  
    end
  end
   
  resources :reservations,only: [:index]
  #get 'my_reservations' => 'reservations#my_reservations'

  root to: "buses#index"
end