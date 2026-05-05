class Avo::Resources::Pelicula < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :permalink, as: :text
    field :imagem, as: :text
    field :imagem_diretor, as: :text
    field :imagem_diretor2, as: :text
    field :imagem_diretor3, as: :text
    field :imagem_producao, as: :text
    field :_id_bos_ingresso_com, as: :text
    field :_id_site_ingresso_com, as: :text
    field :_ingressocom_distribuidora, as: :text
    field :_ingressocom_genero, as: :text
    field :_ingressocom_urlespetaculo, as: :text
    field :_arena_ingressocom_classificacao, as: :number
    field :_arena_ingressocom_fornecedorprincipalid, as: :text
    field :_arena_ingressocom_fornecedores, as: :text
    field :_arena_ingressocom_idiomaoriginalsigla, as: :text
    field :_arena_ingressocom_atribancinecpbroe, as: :text
    field :_arena_ingressocom_tipocopiasigla, as: :text
    field :_arena_ingressocom_tipoexibicaosigla, as: :text
    field :_arena_ingressocom_tipolegendasigla, as: :text
    field :_arena_ingressocom_tipolenteid, as: :text
    field :_arena_ingressocom_tiposom, as: :text
    field :_arena_ingressocom_estabelecimentos, as: :text
    field :_arena_ingressocom_list_estabelecimento, as: :textarea
    field :ano_coord_int, as: :number
    field :biografia_ing_export, as: :textarea
    field :biografia_port_export, as: :textarea
    field :bitola_coord_int, as: :text
    field :catalogo_ficha_2007, as: :textarea
    field :classificacao, as: :number
    field :cor_coord_int, as: :text
    field :diretor_coord_int, as: :text
    field :duracao_coord_int, as: :number
    field :elenco_coord_int, as: :text
    field :fotografia_coord_int, as: :text
    field :idioma_coord_int, as: :text
    field :legenda_coord_int, as: :text
    field :montagem_coord_int, as: :text
    field :musica_coord_int, as: :text
    field :paiscompleto_coord_int, as: :text
    field :producao_coord_int, as: :text
    field :producaoempresa_coord_int, as: :text
    field :roteiro_coord_int, as: :text
    field :seq_pelicula, as: :text
    field :sinopse_ing_export, as: :textarea
    field :sinopse_port_export, as: :textarea
    field :titulo_ingles_coord_int, as: :text
    field :titulo_original_coord_int, as: :text
    field :titulo_portugues_coord_int, as: :text
    field :titulo_ingles_semartigo, as: :text
    field :titulo_original_semartigo, as: :text
    field :titulo_portugues_semartigo, as: :text
    field :website_filme, as: :text
    field :youtube_embed_trailer, as: :textarea
    field :youtube_link_trailer, as: :textarea
    field :vimeo_link_trailer, as: :text
    field :filmecolado, as: :text
    field :filmeliberado, as: :boolean
    field :ativo, as: :boolean
    field :created, as: :date_time
    field :updated, as: :date_time
    field :importacao, as: :belongs_to
    field :edicao, as: :belongs_to
    field :mostra, as: :belongs_to
    field :genero, as: :belongs_to
    field :metragem, as: :belongs_to
    field :atores_peliculas, as: :has_many
    field :galerias, as: :has_many
    field :paises_peliculas, as: :has_many
    field :paises, as: :has_many, through: :paises_peliculas
    field :programacoes, as: :has_many
  end
end
