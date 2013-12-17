Ciese::Application.routes.draw do
  root "static_pages#main"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users do
    put 'deactivate', on: :member
    put 'activate', on: :member
  end

  namespace :admin do
    get "profiles", to: "profiles#index", as: :profiles
    get "profiles/*extra", to: "profiles#index", as: :profiles_sub
  end

  namespace :api do
    resources :profiles, only: [:index, :create, :show, :update, :destroy]
    resources :programs, only: [:index, :create, :show, :update, :destroy]
  end

  resources :boards, :topics, :posts, :comments
  get "/discussion/boards", to: "boards#index"
  get "/discussion/boards/:id/topics", to: "boards#show"
  get "/discussion/topics/:id/posts", to: "topics#show"
  get "/discussion/posts/:id", to: "posts#show"
  get "/discussion/comments/:id", to: "comments#show"

  get "/discussion/posts/:id/edit", to: "posts#edit"
  put "/discussion/posts/:id", to: "posts#update"

  get "/discussion/comments/:id/edit", to: "comments#edit"
  put "/discussion/comments/:id", to: "comments#update"

end
