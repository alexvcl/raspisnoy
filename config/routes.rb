Rails.application.routes.draw do

  root to: 'welcome#index'

  devise_for :users, controllers: {
    sessions:      'auth/sessions',
    confirmations: 'auth/confirmations',
    registrations: 'auth/registrations',
    passwords:     'auth/passwords'
  }

  devise_scope :user do
    root            to: 'games#index'
  end

  resources :games, only: [:index, :new, :create, :show] do
    resources :wizard
  end

end
