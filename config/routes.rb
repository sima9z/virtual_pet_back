Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'signup', to: 'users#create'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get '/check_pets', to: 'pets#check_pets'
  get '/current_user', to: 'users#current_user_action'

  resources :users do
    get 'current_user', on: :collection
  end

  resources :dogs, only: [:create] do
    member do
      post 'feed'
      post 'water'
      post 'walk'
      post 'update_state'
    end
  end

  resources :cats, only: [:create] do
    member do
      post 'feed'
      post 'water'
      post 'walk'
      post 'update_state'
    end
  end
  
end
