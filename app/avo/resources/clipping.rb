class Avo::Resources::Clipping < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :data, as: :date
    field :titulo, as: :text
    field :permalink, as: :text
    field :veiculo, as: :text
    field :imagem, as: :text
    field :upload_arquivo, as: :text
    field :url, as: :textarea
    field :conteudo, as: :textarea
    field :tipo, as: :number
    field :ativo, as: :boolean
    field :created, as: :date_time
    field :updated, as: :date_time
    field :idioma, as: :belongs_to
  end
end
