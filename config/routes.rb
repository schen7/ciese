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
    get "pages", to: "pages#index", as: :current_pages
    get "pages/new", to: "pages#new", as: :new_page
    post "pages", to: "pages#create"
    get "pages/edit/:page_id", to: "pages#edit", as: :edit_page
    post "pages/publish/editor", to: "pages#editor_publish", as: :editor_publish_page
    post "pages/publish/version", to: "pages#version_publish", as: :version_publish_page
    get "pages/:page_id/versions", to: "pages#versions", as: :page_versions
    get "pages/:page_id/versions/:id", to: "pages#show_version", as: :page_version
    
    get "profiles", to: "profiles#index", as: :profiles
    get "profiles/*extra", to: "profiles#index", as: :profiles_sub
  end

  namespace :api do
    resources :pages, only: [:create, :show, :update, :destroy]
    resources :profiles, only: [:index, :create, :show, :update, :destroy]
    resources :programs, only: [:index, :create, :show, :update, :destroy]
  end

  get "*url", to: "render_page#show", as: :render_page, constraints: {url: /(?!rails).*/}

end
