Rails.application.routes.draw do
  root to: 'home#index'
  get '/pages/*id', to: 'pages#show', as: :page, format: false
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :retirement, only: %i[create], controller: 'retirement'
  resources :repositories, only: %i[update]
  resources :users, only: [], path: :contributors do
    resources :assigned_issues, only: %i[index]
    resources :reviewed_issues, only: %i[index]
    resources :issues,  only: %i[index]
    resources :wikis, only: %i[index]
    resources :all_issues, only: %i[index]
  end
  namespace :lazy do
    get 'first_login', to: 'first_login#show'
  end
  get 'first_login', to: 'first_login#show'
end
