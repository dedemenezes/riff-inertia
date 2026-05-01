class Avo::Resources::Caderno < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :nome_en, as: :text
    field :nome_pt, as: :text
    field :permalink_en, as: :text
    field :permalink_pt, as: :text
    field :created, as: :date_time
    field :noticias, as: :has_many
  end
end
