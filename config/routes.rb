Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get ':merchant_id/items', to: 'items#index'
        get 'find_all', to: 'search#index'
        get 'find', to: 'search#show'
        get 'most_items', to: 'items_sold#index'
      end
      namespace :items do
        get ':id/merchant', to: 'merchants#show'
        get 'find_all', to: 'search#index'
        get 'find', to: 'search#show'
      end
      namespace :revenue do
        resources :merchants, only: [:index, :show]
        resources :items, only: [:index]
      end
      get 'revenue', to: 'revenue#total'

      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :merchants, only: [:index, :show]
      # resources :revenue, only: [:total]
    end
  end
end
