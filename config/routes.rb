Rails.application.routes.draw do

  #ログイン時のroot
  authenticated :user do
    root to "top#index", as: :authenticated_root
  end
  #未ログイン時のroot
  unauthenticated do
    root to: "static_pages#top"
  end

  resources :sitting_sessions, only: [ :new, :create, :show ] do
    collection do
      post :subscribe
    end
  end

  resources :exercises, only: [ :index, :show ]

  devise_for :users

  post "guest_login", to: "users/guest_sessions#create"

  get "up" => "rails/health#show", as: :rails_health_check

end
