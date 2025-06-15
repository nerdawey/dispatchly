# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post 'auth/login', to: 'authentication#login'
      
      # Trips (includes dispatch functionality)
      resources :trips, only: [:index, :show, :create, :update, :destroy] do
        collection do
          post :propose
          post :confirm
        end
        member do
          post :optimize
          get :status
          post :complete
        end
      end

      # Failed Dispatches
      resources :failed_dispatches, only: [ :index, :show ] do
        member do
          post :retry
          post :resolve
        end
        collection do
          get :stats
        end
      end

      # Orders
      resources :orders do
        collection do
          post :bulk_create
          post :import_csv
        end
      end

      # Vehicles
      resources :vehicles do
        member do
          get :location
          post :update_location
        end
      end

      # Other resources
      resources :users
      resources :organizations
      resources :products
      resources :locations
    end
  end
end
