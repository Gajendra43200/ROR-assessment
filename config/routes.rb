Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'login', to: 'authentication#login'
  resources :news_articles, only: [:index]
  resources :users do
    resources :blogs do
      resources :posts
    end
  end

  resources :users do
    resources :posts do
      resources :comments
      resources :likes
    end
  end
  resources :users do
    member do
      post 'enable_2fa'
      post 'verify_2fa'
    end
  end
end
