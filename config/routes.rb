Rails.application.routes.draw do
  root to: 'toppages#index'
  
  # Log in / Log out
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # Sign up
  get 'signup', to: 'users#new'
  
  # Users
  resources :users, only: [:index, :show, :new, :create] do
    member do
      get :followings
      get :followers
    end
  end
  
  # Posts
  resources :microposts, only: [:create, :destroy]
  
  # Follows
  resources :relationships, only: [:create, :destroy]
  
  # Favourites
  resources :favourites, only: [:create, :destroy]
end
