class Avo::Resources::Cineencontro < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :nome, as: :text
    field :email, as: :text
    field :telefone, as: :text
    field :cpf, as: :text
    field :created, as: :date_time
    field :updated, as: :date_time
    field :programacao, as: :belongs_to
  end
end
