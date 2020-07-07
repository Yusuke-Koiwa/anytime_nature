Rails.application.routes.draw do
  devise_for :users
  root to: "pictures#index"
  resources :users, only: [:show, :edit, :update] do
    member do
      get "popular"
    end
  end
  resources :pictures do
    resources :favorites, only: [:create, :destroy]
  end
  resources :categories, only: [:index, :show] do
    collection do
      get "children"
    end
  end
end