Rails.application.routes.draw do
  root to: 'home#index'
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
