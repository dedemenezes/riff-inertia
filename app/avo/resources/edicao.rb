class Avo::Resources::Edicao < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :descricao, as: :text
    field :resumo_pt, as: :textarea
    field :resumo_en, as: :textarea
    field :cartaz, as: :text
    field :catalogo, as: :text
    field :data_inicio, as: :date
    field :data_termino, as: :date
    field :programacoes, as: :has_many
    field :mostras, as: :has_many
    field :cinemas, as: :has_many
    field :peliculas, as: :has_many
    field :importacao_convidados, as: :has_many
    field :importacoesprogs, as: :has_many
  end
end
