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
    get "pages", to: "pages#index"
    get "pages/new", to: "pages#new", as: :new_page
    get "pages/:page_id/edit", to: "pages#edit", as: :edit_page
    get "pages/:page_id/versions", to: "pages#versions", as: :page_versions
    get "pages/:page_id/versions/:id", to: "pages#show_version", as: :page_version

    get "forms", to: "forms#index"
    get "forms/new", to: "forms#new", as: :new_form
    get "forms/:form_id/edit", to: "forms#edit", as: :edit_form
    get "forms/:form_id/versions", to: "forms#versions", as: :form_versions
    get "forms/:form_id/versions/:id", to: "forms#show_version", as: :form_version
    get "forms/:form_id/versions/:id/responses", to: "forms#version_responses", as: :form_version_responses
    
    get "profiles", to: "profiles#index", as: :profiles
    get "profiles/*extra", to: "profiles#index", as: :profiles_sub
    get "mediabrowser", to: "mediabrowser#index", as: :mediabrowser
    get "mediabrowser/*extra", to: "mediabrowser#index", as: :mediabrowser_sub

    get "preview/:layout", to: "layout_preview#show", as: :layout_preview
  end

  namespace :api do
    resources :forms, only: [:create, :show, :update, :destroy]
    resources :pages, only: [:create, :show, :update, :destroy]
    resources :profiles, only: [:index, :create, :show, :update, :destroy]
    resources :programs, only: [:index, :create, :show, :update, :destroy]
    get "mediabrowser", to: "mediabrowser#index", as: :mediabrowser
    post "mediabrowser/upload", to: "mediabrowser#upload", as: :mediabrowser_upload
  end

  get "forms/:project/:slug", to: "form_response#new", as: :fill_out_form
  post "forms/:project/:slug", to: "form_response#create"
  get "forms/:project/:slug/done", to: "form_response#show", as: :form_done

  get "*url", to: "render_page#show", as: :render_page, constraints: {url: /(?!rails).*/}

end
