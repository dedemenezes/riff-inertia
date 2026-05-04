class Avo::Resources::Noticia < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  def fields
    field :id, as: :id
    field :imagem, as: :text
    field :data, as: :date
    field :hora, as: :time
    field :caderno, as: :belongs_to, can_create: false, display: :nome_pt
    field :titulo, as: :text
    field :chamada, as: :textarea
    field :conteudo, as: :ckeditor5
    field :ativo, as: :boolean
    field :permalink, as: :text
    # field :created, as: :date_time
    # field :updated, as: :date_time
    field :idioma, as: :belongs_to
  end
end
