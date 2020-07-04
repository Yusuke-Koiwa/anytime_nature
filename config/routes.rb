Rails.application.routes.draw do
  devise_for :users
  root to: "homes#index"
  resources :pictures
  resources :categories, only: [:index, :show] do
    collection do
      get "children"
    end
  end
end