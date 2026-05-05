class Avo::Resources::Genero < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :nome_abreviado, as: :text
    field :permalink_pt, as: :text
    field :permalink_en, as: :text
    field :nome_pt, as: :text
    field :nome_en, as: :text
    field :created, as: :date_time
    field :updated, as: :date_time
    field :peliculas, as: :has_many
  end
end
