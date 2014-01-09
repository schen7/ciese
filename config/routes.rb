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
  get "/discussion/boards", to: "boards#index", as: "discussion_boards"
  get "/discussion/board/:id/edit", to: "boards#edit", as: "discussion_edit_board"
  get "/discussion/board/:id/topics", to: "boards#show", as: "discussion_board"

  get "/discussion/topic/:id/posts", to: "topics#show", as: "discussion_topic"
  get "/discussion/post/:id", to: "posts#show", as: "discussion_post"
  get "/discussion/topic/:id/edit", to: "topics#edit", as: "discussion_edit_topic"

  get "/discussion/comment/:id", to: "comments#show", as: "discussion_comment"

  get "/discussion/post/:id/edit", to: "posts#edit", as: "discussion_edit_post"
  put "/discussion/post/:id", to: "posts#update"

  get "/discussion/comment/:id/edit", to: "comments#edit", as: "discussion_edit_comment"
  put "/discussion/comment/:id", to: "comments#update"

  get "/discussion/post/:id/comment/new", to: "comments#new", as: "discussion_new_comment"
  post "/discussion/post/:id", to: "comments#create", as: "discussion_create_comment"

  get "/discussion/topic/:id/post/new", to: "posts#new", as: "discussion_new_post"
  post "/discussion/topic/:id", to: "posts#create", as: "discussion_create_post"
end
