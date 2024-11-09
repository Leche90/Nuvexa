Rails.application.routes.draw do
  devise_for :users

  # Admin routes
  namespace :admin do
    root "dashboard#index" # Admin dashboard
    resources :products, only: [ :index, :new, :create, :edit, :update, :destroy ]
    resources :orders, only: [ :index, :show, :edit, :update ]
    resources :users, only: [ :index ]
    resources :categories
  end

  # Frontend routes
  root "home#index" # Main store page
  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :index, :show ]
  resources :cart, only: [ :index, :create, :update, :destroy ]
  resources :orders, only: [ :new, :create, :show ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
