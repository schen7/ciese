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
    get "pages/edit/:page_id", to: "pages#edit", as: :edit_page
    post "pages", to: "pages#create"
    post "pages/:page_id", to: "pages#publish"
    get "pages/:page_id/versions", to: "pages#publish", as: :page_versions
    get "profiles", to: "profiles#index", as: :profiles
    get "profiles/*extra", to: "profiles#index", as: :profiles_sub
  end

  namespace :api do
    resources :profiles, only: [:index, :create, :show, :update, :destroy]
    resources :programs, only: [:index, :create, :show, :update, :destroy]
  end

end
