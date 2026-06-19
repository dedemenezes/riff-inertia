class Noticia < ApplicationRecord
  include Imageable

  belongs_to :caderno
  belongs_to :idioma

  validates :data, presence: true
  validates :titulo, presence: true, length: { maximum: 150 }
  validates :permalink, presence: true, length: { maximum: 150 }, uniqueness: true

  def image_path_prefix = "imagens/noticias"
  def image_default_size = "medium2"

  scope :published, -> { where(ativo: true) }

  def display_title
    fragment = Nokogiri::HTML.fragment(titulo.to_s)
    fragment.css("script, style").remove
    fragment.text.squish
  end

  def breadcrumb_title
    "#{display_title.split(" ").first(5).join(" ")}..."
  end

  def caderno_nome
    # pick the correct language dynamically if you support i18n
    I18n.locale == :pt ? caderno&.nome_pt : caderno&.nome_en
  end

  def display_date
    data.strftime("%d.%m.%Y")
  end

  def to_param
    permalink
  end

  def listing_as_json(only:, methods:)
    as_json(only: only, methods: methods).merge("titulo" => display_title)
  end
end
