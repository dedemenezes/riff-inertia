class Avo::Resources::Convidado < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :nome, as: :text
    field :permalink, as: :text
    field :imagem, as: :text
    field :seq_convidado, as: :text
    field :seq_pelicula, as: :text
    field :biografia_en, as: :textarea
    field :biografia_pt, as: :textarea
    field :created, as: :date_time
    field :updated, as: :date_time
    field :pelicula, as: :belongs_to
    field :edicao, as: :belongs_to
    field :importacao_convidado, as: :belongs_to
  end
end
