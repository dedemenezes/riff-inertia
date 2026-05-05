class Avo::Resources::Layout < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :layout_arquivo, as: :text
    field :nome, as: :text
    field :created, as: :date_time
    field :updated, as: :date_time
    field :paginas, as: :has_many
  end
end
