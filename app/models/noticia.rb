class Noticia < ApplicationRecord
  belongs_to :caderno
  belongs_to :idioma

  scope :published, -> { where(ativo: true) }

  def breadcrumb_title
    "#{titulo.split(" ").first(5).join(" ")}..."
  end
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
