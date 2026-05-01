class Avo::Resources::Importacao < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :created, as: :date_time
    field :edicao, as: :belongs_to
    field :mostras, as: :has_many
    field :peliculas, as: :has_many
  end
end
