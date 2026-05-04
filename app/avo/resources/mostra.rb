class Avo::Resources::Mostra < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :nome_abreviado, as: :text
    field :permalink_pt, as: :text
    field :permalink_en, as: :text
    field :filme_destaque_id, as: :number
    field :nome_pt, as: :text
    field :nome_en, as: :text
    field :chamada_pt, as: :textarea
    field :chamada_en, as: :textarea
    field :conteudo_pt, as: :textarea
    field :conteudo_en, as: :textarea
    field :imagem, as: :text
    field :premiere, as: :number
    field :ordem, as: :number
    field :created, as: :date_time
    field :updated, as: :date_time
    field :importacao, as: :belongs_to
    field :edicao, as: :belongs_to
    field :peliculas, as: :has_many
  end
end
