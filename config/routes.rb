Rails.application.routes.draw do
  # topページ
  root "static_pages#top"

  resources :sitting_sessions, only: [ :new, :create, :show ] do
    collection do
      post :subscribe
    end

    member do
      patch :cancel
    end
  end

  resources :exercises, only: [ :index, :show ]

  devise_for :users

  post "guest_login", to: "users/guest_sessions#create"
 
  get "up" => "rails/health#show", as: :rails_health_check

end
