class Avo::Resources::Bairro < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :nome, as: :text
    field :ativo, as: :boolean
    field :created, as: :date_time
    field :cinemas, as: :has_many
  end
end
