class ApplicationRecord < ActiveRecord::Base
  # TODO: update to present year
  EDICAO_ATUAL_ANO = "2024"
  EDICAO_ATUAL = 13
  primary_abstract_class
end
