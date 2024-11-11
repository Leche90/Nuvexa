Rails.application.routes.draw do
  devise_for :users

  # Admin routes
  namespace :admin do
    root "dashboard#index"
    resources :products, only: [ :index, :new, :create, :edit, :update, :destroy ]
    resources :orders, only: [ :index, :show, :edit, :update ]
    resources :users, only: [ :index ]
    resources :categories
  end

  # Frontend routes
  root "home#index"
  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :index, :show ]
  resources :orders, only: [ :new, :create, :show ]
  resources :cart, only: [ :index ] do
    post "add", on: :collection  # This creates the `add_cart_index_path`
    patch "update_quantity", on: :collection
    delete "remove", on: :collection
  end

  # Health check route and PWA files
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
