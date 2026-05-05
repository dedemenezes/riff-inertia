class Avo::Resources::Pagina < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :controller, as: :text
    field :view, as: :text
    field :tipo, as: :text
    field :is_menu, as: :boolean
    field :is_root, as: :boolean
    field :titulo, as: :text
    field :chamada, as: :text
    field :permalink, as: :text
    field :rota, as: :text
    field :url, as: :textarea
    field :conteudo, as: :textarea
    field :ordem, as: :number
    field :ordem_submenu, as: :number
    field :ordem_rodape, as: :number
    field :ativo, as: :boolean
    field :created, as: :date_time
    field :updated, as: :date_time
    field :parent, as: :belongs_to
    field :children, as: :has_many
    field :layout, as: :belongs_to
    field :idioma, as: :belongs_to
  end
end
