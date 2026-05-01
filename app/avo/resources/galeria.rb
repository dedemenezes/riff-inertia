class Avo::Resources::Galeria < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :nome, as: :text
    field :ordem, as: :number
    field :created, as: :date_time
    field :pelicula, as: :belongs_to
  end
end
