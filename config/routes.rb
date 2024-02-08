Rails.application.routes.draw do
  resources :buses do
    resources :reservations do
      collection do 
        get  'my_reservations'
      end
    end
     collection do
      get 'search'  
    end
  end
  resources :bus_owners do
    collection do
      get 'search' 
    end
  end
  #get 'your_buses' => 'bus_owners#index'
  get 'my_reservations' => 'customers#my_reservations'
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  root to: "buses#index"
end