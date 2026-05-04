class Avo::Resources::Webdoor < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.description = "Carrosel exibido na página inicial"
  self.index_query = -> { query.order(ativo: :desc, ordem: :asc) }

  def fields
    # =====================
    # INDEX
    # =====================
    field :ativo, as: :boolean, hide_on: [ :show, :edit, :new ]
    field :titulo, as: :text, hide_on: [ :show, :edit, :new ]
    field :chamada, as: :textarea, hide_on: [ :show, :edit, :new ]
    field :created, as: :date_time, hide_on: [ :show, :edit, :new ]

    # =====================
    # SHOW / EDIT / NEW
    # =====================
    field :imagem, as: :text, hide_on: [ :index ]
    field :imagem_mobile, as: :text, hide_on: [ :index ]
    field :titulo, as: :text, hide_on: [ :index ]
    field :chamada, as: :textarea, hide_on: [ :index ]
    field :url, as: :textarea, hide_on: [ :index ]
    field :destino,
      as: :select,
      hide_on: [ :index ],
      options: { "Mesma aba" => "_self", "Nova aba" => "_blank" }
    field :ativo, as: :boolean, hide_on: [ :index ]

    # =====================
    # OUTROS (se precisar)
    # =====================
    # field :ordem, as: :number, hide_on: [ :index ]
    # field :updated, as: :date_time, hide_on: [ :index ]
    # field :idioma, as: :belongs_to, hide_on: [ :index ]
  end
end
