class Cinema < ApplicationRecord
  belongs_to :bairro
  belongs_to :edicao
  has_many :programacoes

  def filter_value
    id
  end

  def filter_display
    nome
  end

  def filter_label
    I18n.t("filter.cinema")
  end
end
