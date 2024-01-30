Rails.application.routes.draw do
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

  root "welcome#index"

  namespace :authentication, path: "", as: "" do
    resources :users, only: [:new, :create], path: "/register", path_names: { new: "/" }
    resources :sessions, only: [:new, :create, :destroy], path: "/login", path_names: { new: "/" }
  end

  match "*path", to: "application#handle_404", via: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
