class Noticia < ApplicationRecord
  belongs_to :caderno
  belongs_to :idioma

  def caderno_nome
    # pick the correct language dynamically if you support i18n
    I18n.locale == :pt ? caderno&.nome_pt : caderno&.nome_en
  end

  def display_date
    updated.strftime("%d.%m.%Y")
  end

  def to_param
    permalink
  end
end
