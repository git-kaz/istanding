Rails.application.routes.draw do
  # 運動管理画面
  namespace :admin do
    resources :exercises
  end

  get "pages/terms"
  get "pages/privacy"
  # ログイン時のroot
  authenticated :user do
    root "top#index", as: :authenticated_root
  end
  # 未ログイン時のroot
  unauthenticated do
    root "static_pages#top"
  end

  resources :sitting_sessions, only: %i[new create show ] do
    collection do
      post :subscribe
      patch :finish_current
    end
  end

  resources :exercises, only: %i[index show ]

  resources :activity_logs, only: %i[create index ]

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }

  # ゲストログイン
  post "guest_login", to: "users/guest_sessions#create"

  # 利用規約、プライバシーポリシー
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"

  get "up" => "rails/health#show", as: :rails_health_check
end
