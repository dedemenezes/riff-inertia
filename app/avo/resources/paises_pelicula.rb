class Avo::Resources::PaisesPelicula < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :pais, as: :belongs_to
    field :pelicula, as: :belongs_to
  end
end
