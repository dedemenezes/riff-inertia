class Avo::Resources::Torpedo < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :telefone, as: :text
    field :created, as: :date_time
    field :updated, as: :date_time
  end
end
