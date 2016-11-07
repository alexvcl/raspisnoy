Rails.application.routes.draw do

  root to: 'welcome#index'

  # devise_for :players, controllers: {
  #   sessions:      'auth/sessions',
  #   confirmations: 'auth/confirmations',
  #   registrations: 'auth/registrations',
  #   passwords:     'auth/passwords'
  # }

  devise_for :players

  devise_scope :player do
    root            to: 'games#index'
  end

  resources :games, only: [:index, :new, :create, :show] do
    resources :wizard

    post :start, on: :member
  end

end
