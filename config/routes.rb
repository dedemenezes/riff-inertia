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

    resources :edicoes_anteriores, only: [ :index ] do
      get "mostras/premiere-brasil", to: "edicoes/mostras#premiere_brasil", as: :mostras_premiere_brasil
      resources :mostras, only: [ :index, :show ], controller: "edicoes/mostras", param: :permalink
      resources :filmes, only: [ :index ], controller: "edicoes/filmes"
      resources :noticias, only: [ :index ], controller: "edicoes/noticias"
      resources :juri, only: [ :index ], controller: "edicoes/juri", as: :juri
    end
    resources :mostras, only: %i[ index show ], param: :category
    resources :peliculas, only: %i[ index show ], param: :permalink
    resources :cinemas, only: :index
    get :equipe, to: "equipe#index", as: :equipe
    get :imprensa, to: "imprensa#index", as: :imprensa
    get :ingressos, to: "ingressos#index", as: :ingressos
    get :midias, to: "midias#index", as: :midias

    scope :ingressos do
      get "como-comprar", to: "ingressos#como_comprar", as: :ingressos_como_comprar
      get "pacotes", to: "ingressos#pacotes", as: :ingressos_pacotes
      get "proximas-sessoes", to: "ingressos#proximas_sessoes", as: :ingressos_proximas_sessoes
    end

    scope :midias, as: :midias do
      get "fotos-e-videos", to: "midias#fotos_e_videos", as: :fotos_e_videos
      get "impressos", to: "midias#impressos", as: :impressos
    end

    scope :festival do
      get "sobre-nos", to: "sobre_nos#index", as: :festival_sobre_nos
      get "juri", to: "juri#index", as: :festival_juri
      get "parceiros", to: "parceiros#index", as: :festival_parceiros
      get "parceiros/editoriais", to: "parceiros#editoriais", as: :festival_parceiros_editoriais
    end

    scope :talents do
      get :apresentacao, to: "talents#participants", as: :talents_members
      get :noticias_e_criticas, to: "talents#news", as: :talents_news
      get :programacao, to: "talents#programacao", as: :talents_programacao
    end
  end

  get "inertia-example", to: "inertia_example#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
