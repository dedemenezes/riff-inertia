class Destaque < ApplicationRecord
  include Imageable

  belongs_to :idioma
  belongs_to :tipo

  scope :active, -> { where(ativo: 1).order(:ordem) }

  def image_path_prefix = "imagens/destaques"
  def image_default_size = "small"
end
