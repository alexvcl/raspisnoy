Rails.application.routes.draw do

  root to: 'welcome#index'

  # devise_for :players, controllers: {
  #   sessions:      'auth/sessions',
  #   confirmations: 'auth/confirmations',
  #   registrations: 'auth/registrations',
  #   passwords:     'auth/passwords'
  # }

  devise_for :users

  devise_scope :user do
    root            to: 'games#index'
  end

  resources :users do
    # get :players, on: :member
    resources :players, only: [:index]
  end
  resources :players, only: [:edit, :update]
  # resources :players, only: [:index]
  resources :games, only: [:index, :new, :create, :show, :current_round] do
    get :current_round, on: :member
    resources :wizard
    resources :rounds, only: [:show, :betting, :set_orders, :proceed_scores, :set_tricks] do
      member do
       get :betting
       put :set_orders
       get :proceed_scores
       put :set_tricks
      end
    end

    post :start, on: :member
  end

end
