Rails.application.routes.draw do
  root to: 'home#index'
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :retirement, only: %i[create], controller: 'retirement'
  resources :repositories, only: %i[new create destroy] do
    resources :assigned_issues, only: %i[index]
    resources :reviewed_issues, only: %i[index]
  end
end
