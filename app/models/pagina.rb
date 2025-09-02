class Pagina < ApplicationRecord
  belongs_to :parent, class_name: "Pagina", optional: true, foreign_key: "pagina_id"
  has_many :children, class_name: "Pagina", foreign_key: "pagina_id", dependent: :nullify

  belongs_to :layout, optional: true
  belongs_to :idioma
end
