class Avo::Resources::Cinema < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :nome, as: :text
    field :endereco, as: :text
    field :telefone, as: :text
    field :capacidade, as: :text
    field :estado, as: :text
    field :ingresso, as: :number
    field :tipo_venda_codigo, as: :text
    field :seq_cinema, as: :text
    field :seq_estabelecimento, as: :text
    field :created, as: :date_time
    field :updated, as: :date_time
    field :bairro, as: :belongs_to
    field :edicao, as: :belongs_to
    field :programacoes, as: :has_many
  end
end
