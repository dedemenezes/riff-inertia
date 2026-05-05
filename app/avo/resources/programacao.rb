class Avo::Resources::Programacao < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :codigo_com_5_digitos, as: :text
    field :ingresso_url_venda, as: :textarea
    field :ingresso_enabled, as: :boolean
    field :ingresso_block_message, as: :text
    field :url_inscricao_gratuitas, as: :textarea
    field :data, as: :date
    field :sessao, as: :date_time
    field :legnacopia, as: :text
    field :sessao_gala, as: :boolean
    field :sessao_debate, as: :boolean
    field :sessao_colada, as: :boolean
    field :filmecolado, as: :text
    field :sessao_fechada_manual, as: :boolean
    field :gratuito, as: :boolean
    field :gratuidade_limitada, as: :boolean
    field :acessibilidade, as: :boolean
    field :deletado, as: :boolean
    field :created, as: :date_time
    field :updated, as: :date_time
    field :cineencontros, as: :has_many
    field :cinema, as: :belongs_to
    field :pelicula, as: :belongs_to
    field :importacoesprog, as: :belongs_to
    field :edicao, as: :belongs_to
    field :logs, as: :has_many
  end
end
