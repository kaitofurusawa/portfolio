Rails.application.routes.draw do
  # トップページ
  root 'boards#index'

  # ユーザー登録関連（sorcery用）
  resources :users, only: [:new, :create, :show, :edit, :update]

  # ログイン・ログアウト関連（sorcery用）
  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # 掲示板（boards）のルーティング
  resources :boards
end
