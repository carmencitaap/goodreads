Rails.application.routes.draw do
  resources :sales
  resources :reviews
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "pages#home"

  resources :authors

  get 'authors_stats', to: 'authors#authors_stats', as: 'stats'
  get 'top_10_rated_books', to: 'books#top_10_rated_books', as: 'top_10_rated_books'
end
