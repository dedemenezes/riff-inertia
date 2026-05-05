class Avo::Resources::AtoresPelicula < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :ator, as: :belongs_to
    field :pelicula, as: :belongs_to
  end
end
