class Avo::Resources::Ator < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  #
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :nome_ator, as: :text
    field :atores_peliculas, as: :has_many
  end
end
