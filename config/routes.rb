Rails.application.routes.draw do
  devise_for :users
  root to: "pictures#index"
  resources :users, only: %i[show edit update] do
    resources :relationships, only: %i[create destroy]
    collection do
      get :favorite
    end
    member do
      get :slideshow, :following, :follower
    end
  end
  resources :pictures, exept: :edit do
    collection do
      get :slideshow
    end
    resources :favorites, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end
  resources :categories, only: %i[index show] do
    collection do
      get :children
    end
    member do
      get :slideshow
    end
  end
  resources :tags, only: :show do
    member do 
      get :slideshow
    end
  end
  resources :notifications, only: :index
  get "/users/favorite/:picture_id", to: "users#favorite_show"
  get "/users/:id/:picture_id", to: "users#post_show"
  get "/categories/parent/:id/:picture_id", to: "categories#parent_picture"
  get "/categories/:id/:picture_id", to: "categories#picture"
  get "/tags/:id/:picture_id", to: "tags#picture"
end