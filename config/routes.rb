Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '', to: 'merchants#index'
        get ':id', to: 'merchants#show'
        get ':merchant_id/items', to: 'items#index'
      end
      namespace :items do
        get '', to: 'items#index'
        get ':id', to: 'items#show'
      end
    end
  end
end
