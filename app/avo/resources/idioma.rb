class Avo::Resources::Idioma < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false
  self.title = :nome

  def fields
    field :id, as: :id
    field :nome, as: :text
    field :locale, as: :text
    field :clippings, as: :has_many
    field :noticias, as: :has_many
    field :paginas, as: :has_many
    field :videos, as: :has_many
    field :webdoors, as: :has_many
  end
end
