Rails.application.routes.draw do
  devise_for :users
  root to: "homes#index"
end
