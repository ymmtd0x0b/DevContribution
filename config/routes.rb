Rails.application.routes.draw do
  root to: 'home#index'
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :retirement, only: %i[create], controller: 'retirement'
  resources :repositories, only: %i[new create destroy] do
    namespace :issues do
      resources :assigned, only: %i[index]
      resources :reviewed, only: %i[index]
      resources :created,  only: %i[index]
    end
    resources :wikis,  only: %i[index]
    resources :deliverables, only: %i[index]
  end
end
