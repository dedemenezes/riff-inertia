class Programacao < ApplicationRecord
  has_many :cineencontros
  belongs_to :cinema
  belongs_to :pelicula
  belongs_to :importacoesprog
  belongs_to :edicao
  has_many :logs


  def display_sessao
    sessao.strftime("%H:%M")
  end

  def filter_value
    sessao.strftime("%Hh%M")
  end

  def filter_display
    sessao.strftime("%Hh%M")
  end

  def filter_label
    I18n.t("filter.time")
  end
end
