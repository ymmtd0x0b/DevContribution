Rails.application.routes.draw do
  root to: 'home#index'
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :retirement, only: %i[create], controller: 'retirement'
  resources :collaborations, only: %i[new create destroy]
  resources :repositories, only: %i[update] do
    scope module: :repositories do
      namespace :issues do
        resources :assign, only: %i[index]
        resources :review, only: %i[index]
        resources :create,  only: %i[index]
      end
      resources :wikis, only: %i[index]
      resources :all, only: %i[index]
    end
  end
end
