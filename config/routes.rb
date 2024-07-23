Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'signup', to: 'users#create'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users
  resource :dog do
    member do
      post 'feed'
      post 'water'
      post 'walk'
      post 'update_state'
    end
  end

  get '/check_pets', to: 'pets#check_pets'
end
