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

  def display_date
    if I18n.locale == :pt
      I18n.l(self.data, format: "%a, %e %b", locale: :pt).split(" ").map(&:strip).join(" ")
    else
      I18n.l(self.data, format: "%a, %b %e", locale: :en).split(" ").map(&:strip).join(" ")
    end
  end

  def cinema_name
    cinema.nome
  end

  def cinema_address
    cinema.endereco
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
