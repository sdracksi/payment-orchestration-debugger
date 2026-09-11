Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health", to: "health#index"
      
      resources :transactions, only: [:index, :show]

    end
  end
end