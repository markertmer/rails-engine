Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get ':merchant_id/items', to: 'items#index'
        get 'find_all', to: 'search#index'
        get 'find', to: 'search#show'
      end
      namespace :items do
        get ':id/merchant', to: 'merchants#show'
        get 'find_all', to: 'search#index'
        get 'find', to: 'search#show'
      end
      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :merchants, only: [:index, :show]
    end
  end
end
