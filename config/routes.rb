Rails.application.routes.draw do
  # Avo + Devise are scoped to dev/test only.
  # Legacy app remains the source of truth for writes and admin
  # until the gradual migration is complete (RIFF-44).
  if Rails.env.local?
    devise_for :usuarios
    mount_avo
  end

  resources :newsletters, only: :create

  scope "(:locale)", locale: /en|pt/ do
    root "pages#home"
    get :programacao, to: "programs#index", as: :program
    resources :noticias, only: %i[ index show ], param: :permalink
    # other localized routes

    resources :edicoes_anteriores, only: %i[ index ]
    resources :mostras, only: %i[ index show ], param: :category
    resources :peliculas, only: %i[ index show ], param: :permalink
    resources :cinemas, only: :index
    get :equipe, to: "equipe#index", as: :equipe
  end

  get "inertia-example", to: "inertia_example#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
