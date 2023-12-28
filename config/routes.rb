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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
