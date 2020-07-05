Rails.application.routes.draw do
  devise_for :users
  root to: "pictures#index"
  resources :users, only: [:show, :edit, :update]
  resources :pictures
  resources :categories, only: [:index, :show] do
    collection do
      get "children"
    end
  end
end