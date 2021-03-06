Rails.application.routes.draw do

  get "sessions/new"

  scope "(:locale)", locale: /en|vi/ do
    get "/home", to: "static_pages#home"

    get "/help", to: "static_pages#help"

    get "/about", to: "static_pages#about"

    get "/contact", to: "static_pages#contact"

    get "/signup", to: "users#new"

    root "static_pages#home"

    post "/signup",  to: "users#create"

    get "/login", to: "sessions#new"

    post "/login", to: "sessions#create"

    delete "/logout", to: "sessions#destroy"

    resources :relationships, only: %i(create destroy)

    resources :users do
      member do
        resources :followings, :followers, only: :index
      end
    end

    resources :account_activations, only: [:edit]

    resources :password_resets, only: [:new, :create, :edit, :update]

    resources :microposts, only: [:create, :destroy]
  end
end
