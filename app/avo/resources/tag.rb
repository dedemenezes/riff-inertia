class Avo::Resources::Tag < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :nome, as: :text
    field :permalink, as: :text
    field :created, as: :date_time
  end
end
