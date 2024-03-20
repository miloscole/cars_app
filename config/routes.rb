Rails.application.routes.draw do
  root to: "welcome#index", via: :get

  resources :customers do
    member do
      get :delete
    end
  end

  resources :cars do
    member do
      get :delete
    end
  end

  namespace :authentication, path: "", as: "" do
    resources :users, only: [:new, :create], path: "/register", path_names: { new: "" }
    resources :sessions, only: [:new, :create, :destroy], path: "/login", path_names: { new: "" }
  end

  get "password", to: "passwords#edit"
  patch "password", to: "passwords#update"

  get "password/reset", to: "password_resets#new"
  post "password/reset", to: "password_resets#create"
  get "password/reset/edit", to: "password_resets#edit"
  patch "password/reset/edit", to: "password_resets#update"

  match "*path", to: "application#handle_404", via: :all
end
