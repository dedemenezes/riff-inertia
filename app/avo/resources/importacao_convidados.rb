class Avo::Resources::ImportacaoConvidados < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :created, as: :date_time
    field :edicao, as: :belongs_to
  end
end
