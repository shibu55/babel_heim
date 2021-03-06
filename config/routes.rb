Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  resources :seats, only: [:index, :create, :update]
  put 'all_seats', to: 'seats#update_all', as: 'all_seats'
  post 'regular', to: 'holidays#create_regular_holidays', as: 'regular_holidays'
  resources :holidays

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
