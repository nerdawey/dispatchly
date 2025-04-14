# config/routes.rb
Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  namespace :api do
    namespace :v1 do
      post '/login', to: 'authentication#login'
      
      resources :organizations
      resources :users
      resources :locations
      resources :vehicles
      resources :products
      resources :orders do
        resources :order_items
      end
      resources :dispatch_plans do
        member do
          post 'optimize'
        end
        resources :assignments
      end
    end
  end
end