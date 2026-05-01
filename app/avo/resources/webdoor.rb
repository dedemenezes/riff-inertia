class Avo::Resources::Webdoor < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :titulo, as: :text
    field :chamada, as: :textarea
    field :imagem, as: :text
    field :imagem_mobile, as: :text
    field :url, as: :textarea
    field :destino, as: :text
    field :ordem, as: :number
    field :ativo, as: :boolean
    field :created, as: :date_time
    field :updated, as: :date_time
    field :idioma, as: :belongs_to
  end
end
