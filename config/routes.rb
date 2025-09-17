Rails.application.routes.draw do
  resources :newsletters, only: :create

  root "pages#home"

  scope "(:locale)", locale: /en|pt/ do
    root "pages#home"
    get :programacao, to: "programs#index", as: :program
    resources :noticias, only: %i[ index show ], param: :permalink
    # other localized routes

    resources :edicoes_anteriores, only: %i[ index ]
    resources :mostras, only: %i[ index show ], param: :category
    resources :peliculas, only: %i[ index show ], param: :permalink
    resources :cinemas, only: :index
  end


  get "inertia-example", to: "inertia_example#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
