class Avo::Resources::Noticia < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :data, as: :date
    field :hora, as: :date_time
    field :titulo, as: :text
    field :permalink, as: :text
    field :imagem, as: :text
    field :chamada, as: :textarea
    field :conteudo, as: :textarea
    field :ativo, as: :boolean
    field :created, as: :date_time
    field :updated, as: :date_time
    field :caderno, as: :belongs_to
    field :idioma, as: :belongs_to
  end
end
