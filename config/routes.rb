Rails.application.routes.draw do
  get "static_pages/terms"
  get "static_pages/privacy"
  get "password_resets/new"
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  # トップページ
  root "boards#index"

  # ユーザー登録関連（sorcery用）
  resources :users, only: [ :new, :create, :show, :edit, :update ] do
    member do
      get :boards
      get :bookmarks
    end
  end

  # ログイン・ログアウト関連（sorcery用）
  resources :sessions, only: [ :new, :create, :destroy ]
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # 掲示板（boards）のルーティング
  resources :boards do
    resources :comments, only: [ :create, :update, :destroy, :edit ]
    resource :bookmark, only: [ :create, :destroy ], module: :boards
    collection do
      get :autocomplete
    end
  end

  # パスワードリセット関連（sorcery用）
  resources :password_resets, only: [ :new, :create, :edit, :update ]

  # 投票関連
  resources :votes, only: [ :create ]

  # 利用規約とプライバシーポリシー
  get "terms", to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"

  # Omniauth認証（Google OAuth2）
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: redirect("/")

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
