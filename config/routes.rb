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
  get "/users/favorite/:picture_id", to: "users#favorite_show"
  get "/users/:id/popular/:picture_id", to: "users#popular_show"
  get "/users/:id/:picture_id", to: "users#post_show"
  get "/categories/parent/:id/:picture_id", to: "categories#parent_picture"
  get "/categories/:id/:picture_id", to: "categories#picture"
end