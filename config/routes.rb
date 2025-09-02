Rails.application.routes.draw do
  root "pages#home"
  get :programacao, to: "programs#index", as: :program
  scope "(:locale)", locale: /en|pt/ do
    resources :noticias, only: [ :show ], param: :permalink
    # other localized routes
  end


  get "inertia-example", to: "inertia_example#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
