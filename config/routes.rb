Rails.application.routes.draw do
  devise_for :users
  root to: "pictures#index"
  resources :users, only: %i[show edit update] do
    resources :relationships, only: %i[create destroy]
    collection do
      get :favorite
    end
    member do
      get :popular, :following, :follower
    end
  end
  resources :pictures do
    resources :favorites, only: %i[create destroy]
  end
  resources :categories, only: %i[index show] do
    collection do
      get :children
    end
  end
end