Rails.application.routes.draw do

  root 'pages#home'

  # get ':identity', to: 'people#show', as: :person
  resources :members do
    # match '/people/:id', to: 'people#show', :via => 'get', as: 'person'
    member do
      match 'authenticate', to: 'members#authenticate', :via => 'post'
      post 'enroll', to: 'members#enroll'
      post 'unenroll', to: 'members#unenroll'
    end
  end

  get    'login',   to: 'sessions#new'
  post   'login',   to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users

  resources :templates

  post 'verify', to: 'members#verify'
  get 'accepted', to: 'members#accepted'
  get 'rejected', to: 'members#rejected'
  get 'how', to: 'pages#how'
end
