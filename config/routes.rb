Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  resources :seats, only: [:index, :create, :update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
