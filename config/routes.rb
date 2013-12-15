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
    post "pages/:page_id", to: "pages#publish"
    get "pages/:page_id/versions", to: "pages#versions", as: :page_versions
    get "pages/:page_id/versions/:id", to: "pages#show_version", as: :show_page_version
    get "pages/edit/:page_id", to: "pages#edit", as: :edit_page
    get "profiles", to: "profiles#index", as: :profiles
    get "profiles/*extra", to: "profiles#index", as: :profiles_sub
  end

  namespace :api do
    resources :profiles, only: [:index, :create, :show, :update, :destroy]
    resources :programs, only: [:index, :create, :show, :update, :destroy]
  end

end
