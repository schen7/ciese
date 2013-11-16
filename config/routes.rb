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
    get "mediabrowser", to: "mediabrowser#index", as: :mediabrowser
    get "mediabrowser/*extra", to: "mediabrowser#index", as: :mediabrowser_sub
  end

  namespace :api do
    resources :profiles, only: [:index, :create, :show, :update, :destroy]
    resources :programs, only: [:index, :create, :show, :update, :destroy]
    get "mediabrowser", to: "mediabrowser#index", as: :mediabrowser
    post "mediabrowser/upload", to: "mediabrowser#upload", as: :mediabrowser_upload
  end

end
