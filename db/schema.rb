# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 0) do
  create_table "atores", id: { type: :integer, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome_ator", limit: 50, null: false
  end

  create_table "atores_peliculas", id: { type: :integer, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.integer "ator_id", null: false, unsigned: true
    t.integer "pelicula_id", null: false
    t.index ["ator_id"], name: "fk_atores_pelicula_idx_idx"
    t.index ["pelicula_id"], name: "fk_pelicula_id_atores_peliculas_idx"
  end

  create_table "bairros", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome", limit: 150, null: false
    t.integer "ativo", null: false
    t.datetime "created", precision: nil, null: false
    t.index ["nome"], name: "idx_bairro_nome"
  end

  create_table "cadernos", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome_en", limit: 150, null: false
    t.string "nome_pt", limit: 150, null: false
    t.string "permalink_en", limit: 150, default: "", null: false
    t.string "permalink_pt", limit: 150, default: "", null: false
    t.datetime "created", precision: nil, null: false
  end

  create_table "cineencontros", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "programacao_id", null: false
    t.string "nome", limit: 150, default: "", null: false
    t.string "email", limit: 150, default: "", null: false
    t.string "telefone", limit: 45, default: "", null: false
    t.string "cpf", limit: 20
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["cpf"], name: "idx_cpf"
    t.index ["email"], name: "idx_email"
    t.index ["programacao_id"], name: "fk_programacao_inscricao_idx"
  end

  create_table "cinemas", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "bairro_id", null: false
    t.integer "edicao_id"
    t.string "nome", limit: 150, null: false
    t.string "endereco", limit: 150
    t.string "telefone", limit: 50
    t.string "capacidade", limit: 50
    t.string "estado", limit: 2
    t.integer "ingresso", default: 0, null: false
    t.string "tipo_venda_codigo", limit: 20
    t.string "seq_cinema", limit: 45
    t.string "seq_estabelecimento", limit: 45
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["bairro_id"], name: "fk_bairro_id_idx"
    t.index ["edicao_id"], name: "idx_edicao_id"
    t.index ["nome"], name: "idx_bairro_nome"
  end

  create_table "clippings", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "idioma_id", null: false
    t.date "data", null: false
    t.string "titulo", limit: 150, null: false
    t.string "permalink", limit: 150, null: false
    t.string "veiculo", limit: 150
    t.string "imagem", limit: 150
    t.string "upload_arquivo"
    t.text "url"
    t.text "conteudo", size: :long
    t.integer "tipo", default: 1
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo"], name: "idx_clipping_ativo"
    t.index ["idioma_id"], name: "fk_clippings_idiomas"
    t.index ["permalink"], name: "idx_clipping_permalink"
  end

  create_table "convidados", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "importacao_convidado_id", null: false
    t.integer "pelicula_id", null: false
    t.integer "edicao_id", null: false
    t.string "nome", limit: 150, null: false
    t.string "permalink", limit: 150, null: false
    t.string "imagem"
    t.string "seq_convidado", limit: 45
    t.string "seq_pelicula", limit: 45
    t.text "biografia_en", size: :long
    t.text "biografia_pt", size: :long
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["edicao_id"], name: "idx_edicao_id"
    t.index ["importacao_convidado_id"], name: "idx_importacao_convidado_id"
    t.index ["pelicula_id"], name: "idx_pelicula_id"
    t.index ["permalink"], name: "fk_permalink"
  end

  create_table "destaques", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "idioma_id", null: false
    t.integer "tipo_id", null: false
    t.string "titulo", default: "", null: false
    t.string "imagem", limit: 150
    t.text "url"
    t.string "destino", limit: 10
    t.integer "ordem", default: 0
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo"], name: "idx_destaque_ativo"
    t.index ["idioma_id"], name: "fk_destaque_idioma"
    t.index ["tipo_id"], name: "fk_destaque_tipo"
  end

  create_table "edicoes", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "descricao", limit: 50, null: false
    t.text "resumo_pt"
    t.text "resumo_en"
    t.string "cartaz"
    t.string "catalogo"
    t.date "data_inicio", null: false
    t.date "data_termino", null: false
  end

  create_table "galerias", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "pelicula_id", null: false
    t.string "nome", null: false
    t.integer "ordem", default: 0
    t.datetime "created", precision: nil, null: false
    t.index ["pelicula_id"], name: "fk_pelicula_galeria_idx"
  end

  create_table "idiomas", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome", limit: 45, null: false
    t.string "locale", limit: 45, null: false
    t.index ["locale"], name: "idiomas_locale_idx", length: 3
  end

  create_table "importacao_convidados", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "edicao_id", null: false
    t.datetime "created", precision: nil, null: false
    t.index ["edicao_id"], name: "idx_edicao_id"
  end

  create_table "importacoes", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "edicao_id"
    t.datetime "created", precision: nil, null: false
  end

  create_table "importacoesprogs", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "edicao_id"
    t.datetime "created", precision: nil, null: false
  end

  create_table "layouts", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "layout_arquivo", limit: 45, null: false
    t.string "nome", limit: 45, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
  end

  create_table "logs", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "programacao_id", null: false
    t.string "acao", limit: 1, default: "c", null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
  end

  create_table "mostras", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "importacao_id", null: false
    t.integer "edicao_id"
    t.string "nome_abreviado", limit: 150
    t.string "permalink_pt", null: false
    t.string "permalink_en", null: false
    t.integer "filme_destaque_id"
    t.string "nome_pt", limit: 150
    t.string "nome_en", limit: 150
    t.text "chamada_pt"
    t.text "chamada_en"
    t.text "conteudo_pt", size: :long
    t.text "conteudo_en", size: :long
    t.string "imagem"
    t.integer "premiere", default: 0, null: false
    t.integer "ordem", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["edicao_id"], name: "fk_importacao_edicoes_id"
    t.index ["filme_destaque_id"], name: "idx_filme_destaque_id"
    t.index ["importacao_id"], name: "fk_importacao_mostras_id_idx"
    t.index ["permalink_en"], name: "idx_permalink_en"
    t.index ["permalink_pt"], name: "idx_permalink_pt"
  end

  create_table "mostras_bkp", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "importacao_id", null: false
    t.string "nome_abreviado", limit: 150
    t.string "permalink_pt", null: false
    t.string "permalink_en", null: false
    t.integer "filme_destaque_id"
    t.string "nome_pt", limit: 150
    t.string "nome_en", limit: 150
    t.text "chamada_pt"
    t.text "chamada_en"
    t.text "conteudo_pt", size: :long
    t.text "conteudo_en", size: :long
    t.string "imagem"
    t.integer "ordem", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
  end

  create_table "newsletters", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["email"], name: "email"
    t.index ["email"], name: "email_2", unique: true
  end

  create_table "noticias", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "idioma_id", null: false
    t.integer "caderno_id", null: false
    t.date "data", null: false
    t.time "hora"
    t.string "titulo", limit: 150, null: false
    t.string "permalink", limit: 150, null: false
    t.string "imagem", limit: 150
    t.text "chamada"
    t.text "conteudo", size: :long
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo", "data", "hora"], name: "idx_noticia_ativa"
    t.index ["caderno_id"], name: "fk_noticia_caderno"
    t.index ["idioma_id"], name: "fk_noticia_idioma"
    t.index ["permalink"], name: "idx_noticia_permalink"
  end

  create_table "paginas", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "idioma_id", null: false
    t.integer "pagina_id"
    t.integer "layout_id"
    t.string "controller", limit: 150, default: "", null: false
    t.string "view", limit: 150, default: "", null: false
    t.string "tipo", limit: 1, null: false
    t.integer "is_menu", default: 0, null: false
    t.integer "is_root", default: 0, null: false
    t.string "titulo", limit: 150, null: false
    t.string "chamada", default: "", null: false
    t.string "permalink", limit: 150
    t.string "rota", limit: 150, null: false
    t.text "url"
    t.text "conteudo", size: :long
    t.integer "ordem", default: 0, null: false
    t.integer "ordem_submenu", default: 0, null: false
    t.integer "ordem_rodape", default: 0, null: false
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo"], name: "paginas_ativo_idx"
    t.index ["idioma_id"], name: "idioma_id"
    t.index ["layout_id"], name: "layout_id"
    t.index ["pagina_id", "is_menu", "is_root", "ativo"], name: "paginas_menu_idx"
    t.index ["pagina_id"], name: "fk_pagina_id"
    t.index ["permalink"], name: "paginas_permalink_idx"
    t.index ["rota"], name: "paginas_rota_idx"
    t.index ["tipo", "ativo", "rota", "idioma_id"], name: "paginas_busca_routes_idx"
    t.index ["tipo"], name: "paginas_tipo_idx"
  end

  create_table "paises", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome_pais", limit: 100, null: false
  end

  create_table "paises_peliculas", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "pais_id", null: false
    t.integer "pelicula_id", null: false
    t.index ["pais_id"], name: "fk_paises_atores_paises_idx_idx"
    t.index ["pelicula_id"], name: "fk_paises_peliculas_peliculas_idx_idx"
  end

  create_table "peliculas", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "importacao_id", null: false
    t.integer "edicao_id"
    t.string "permalink", null: false
    t.integer "mostra_id"
    t.string "imagem"
    t.string "imagem_diretor"
    t.string "imagem_diretor2"
    t.string "imagem_diretor3"
    t.string "imagem_producao"
    t.string "_id_bos_ingresso_com"
    t.string "_id_site_ingresso_com"
    t.string "_ingressocom_distribuidora"
    t.string "_ingressocom_genero"
    t.string "_ingressocom_urlespetaculo"
    t.integer "_arena_ingressocom_classificacao", default: 0
    t.string "_arena_ingressocom_fornecedorprincipalid"
    t.string "_arena_ingressocom_fornecedores"
    t.string "_arena_ingressocom_idiomaoriginalsigla", limit: 10
    t.string "_arena_ingressocom_atribancinecpbroe"
    t.string "_arena_ingressocom_tipocopiasigla", limit: 10
    t.string "_arena_ingressocom_tipoexibicaosigla", limit: 10
    t.string "_arena_ingressocom_tipolegendasigla", limit: 10
    t.string "_arena_ingressocom_tipolenteid", limit: 10
    t.string "_arena_ingressocom_tiposom", limit: 10
    t.string "_arena_ingressocom_estabelecimentos", limit: 20
    t.text "_arena_ingressocom_list_estabelecimento"
    t.integer "ano_coord_int"
    t.text "biografia_ing_export", size: :long
    t.text "biografia_port_export", size: :long
    t.string "bitola_coord_int", limit: 45
    t.text "catalogo_ficha_2007"
    t.integer "classificacao"
    t.string "cor_coord_int", limit: 45
    t.string "diretor_coord_int"
    t.integer "duracao_coord_int"
    t.string "elenco_coord_int"
    t.string "fotografia_coord_int"
    t.string "idioma_coord_int", limit: 45
    t.string "legenda_coord_int", limit: 45
    t.string "montagem_coord_int", limit: 45
    t.string "musica_coord_int", limit: 45
    t.string "paiscompleto_coord_int", limit: 45
    t.string "producao_coord_int"
    t.string "producaoempresa_coord_int"
    t.string "roteiro_coord_int"
    t.string "seq_pelicula", limit: 45
    t.text "sinopse_ing_export"
    t.text "sinopse_port_export"
    t.string "titulo_ingles_coord_int"
    t.string "titulo_original_coord_int"
    t.string "titulo_portugues_coord_int"
    t.string "titulo_ingles_semartigo"
    t.string "titulo_original_semartigo"
    t.string "titulo_portugues_semartigo"
    t.string "website_filme"
    t.text "youtube_embed_trailer"
    t.text "youtube_link_trailer"
    t.string "vimeo_link_trailer"
    t.string "filmecolado", limit: 50
    t.integer "filmeliberado", default: 0
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo"], name: "idx_ativo"
    t.index ["edicao_id"], name: "fk_edicao_id_peliculas_idx"
    t.index ["importacao_id"], name: "fk_importacao_id_idx"
    t.index ["mostra_id"], name: "idx_mostra_id"
    t.index ["permalink"], name: "idx_permalink"
  end

  create_table "peliculas_tags", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "pelicula_id", null: false
    t.integer "tag_id", null: false
    t.index ["pelicula_id"], name: "fk_pelicula_id_tags"
    t.index ["tag_id"], name: "fk_peliculas_tags_id"
  end

  create_table "perfis", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome", limit: 150, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
  end

  create_table "programacoes", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "cinema_id", null: false
    t.integer "pelicula_id", null: false
    t.integer "importacoesprog_id", null: false
    t.integer "edicao_id"
    t.string "codigo_com_5_digitos", limit: 5
    t.text "ingresso_url_venda", size: :long
    t.date "data"
    t.time "sessao"
    t.string "legnacopia", limit: 150
    t.integer "sessao_gala", default: 0, null: false
    t.integer "sessao_cineencontro", default: 0, null: false
    t.string "filmecolado", limit: 50
    t.integer "sessao_fechada_manual", default: 0, null: false
    t.integer "gratuito", default: 0, null: false
    t.integer "acessibilidade", default: 0, null: false
    t.integer "deletado", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["acessibilidade"], name: "idx_acessibilidade"
    t.index ["cinema_id", "pelicula_id", "data", "sessao"], name: "idx_programacao_id", unique: true
    t.index ["data"], name: "idx_data_programacao"
    t.index ["deletado"], name: "idx_deletado"
    t.index ["edicao_id"], name: "idx_edicao_id"
    t.index ["gratuito"], name: "idx_gratuito"
    t.index ["importacoesprog_id"], name: "fk_importacoesprog_id_idx"
    t.index ["pelicula_id"], name: "fk_pelicula_id_idx"
    t.index ["sessao"], name: "idx_sessao_programacao"
    t.index ["sessao_gala"], name: "idx_sessao_gala"
  end

  create_table "tags", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome", limit: 150, null: false
    t.string "permalink", limit: 150, null: false
    t.datetime "created", precision: nil, null: false
    t.index ["permalink"], name: "idx_tag_permalink"
  end

  create_table "tipos", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "nome_en", limit: 150, default: "", null: false
    t.string "nome_pt", limit: 150, default: "", null: false
    t.string "permalink_en", limit: 150, default: "", null: false
    t.string "permalink_pt", limit: 150, default: "", null: false
    t.datetime "created", precision: nil, null: false
  end

  create_table "torpedos", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "telefone", default: "", null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
  end

  create_table "usuarios", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "idioma_id", null: false
    t.integer "perfil_id", null: false
    t.string "imagem", null: false
    t.string "nome", limit: 150, null: false
    t.string "sobrenome", limit: 150, null: false
    t.date "nascimento", null: false
    t.string "sexo", limit: 1, null: false
    t.string "email", null: false
    t.string "senha", null: false
    t.string "facebook_id"
    t.datetime "ultimo_login", precision: nil
    t.integer "quantidade_logins"
    t.integer "sessoes", default: 0, null: false
    t.integer "newsletter", default: 0, null: false
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo"], name: "idx_usuario_ativo"
    t.index ["email", "senha"], name: "idx_usuario_login"
    t.index ["email"], name: "email_UNIQUE", unique: true
    t.index ["facebook_id"], name: "idx_usuario_facebook"
    t.index ["idioma_id"], name: "fk_usuario_idioma"
    t.index ["perfil_id"], name: "fk_usuario_perfil"
    t.index ["sexo"], name: "idx_usuario_sexo"
  end

  create_table "videos", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "idioma_id", null: false
    t.string "titulo", limit: 150, null: false
    t.text "url", null: false
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo"], name: "idx_video_ativo"
    t.index ["idioma_id"], name: "fk_video_idioma"
  end

  create_table "webdoors", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "idioma_id", null: false
    t.string "titulo", limit: 150, null: false
    t.text "chamada", null: false
    t.string "imagem", limit: 150
    t.string "imagem_mobile", limit: 150
    t.text "url"
    t.string "destino", limit: 10
    t.integer "ordem", default: 0
    t.integer "ativo", default: 0, null: false
    t.datetime "created", precision: nil, null: false
    t.datetime "updated", precision: nil, null: false
    t.index ["ativo"], name: "idx_webdoor_ativo"
    t.index ["idioma_id"], name: "fk_webdoor_idioma"
  end

  add_foreign_key "atores_peliculas", "atores", name: "fk_ator_id_atores_peliculas", on_delete: :cascade
  add_foreign_key "atores_peliculas", "peliculas", name: "fk_pelicula_id_atores_peliculas", on_delete: :cascade
  add_foreign_key "cineencontros", "programacoes", name: "fk_programacao_inscricao"
  add_foreign_key "cinemas", "bairros", name: "fk_bairro_id", on_delete: :cascade
  add_foreign_key "cinemas", "edicoes", name: "fk_edicao_id_cinemas", on_delete: :cascade
  add_foreign_key "clippings", "idiomas", name: "clippings_ibfk_1", on_delete: :cascade
  add_foreign_key "galerias", "peliculas", name: "fk_pelicula_galeria", on_delete: :cascade
  add_foreign_key "mostras", "edicoes", name: "fk_importacao_edicoes_id", on_delete: :cascade
  add_foreign_key "mostras", "importacoes", name: "fk_importacao_mostras_id", on_delete: :cascade
  add_foreign_key "noticias", "cadernos", name: "noticias_cadernos_id"
  add_foreign_key "noticias", "idiomas", name: "noticias_ibfk_1", on_delete: :cascade
  add_foreign_key "noticias", "idiomas", name: "noticias_idiomas_id", on_delete: :cascade
  add_foreign_key "paginas", "idiomas", name: "fk_pagina_idioma_idx"
  add_foreign_key "paginas", "layouts", name: "fk_pagina_layout_idx"
  add_foreign_key "paginas", "paginas", name: "fk_pagina_pagina_idx"
  add_foreign_key "paises_peliculas", "paises", name: "fk_paises_peliculas_paises_idx", on_delete: :cascade
  add_foreign_key "paises_peliculas", "peliculas", name: "fk_paises_peliculas_peliculas_idx", on_delete: :cascade
  add_foreign_key "peliculas", "edicoes", name: "fk_edicao_id_peliculas", on_delete: :cascade
  add_foreign_key "peliculas", "importacoes", name: "fk_importacao_id", on_delete: :cascade
  add_foreign_key "peliculas", "mostras", name: "fk_mostra_id_peliculas", on_delete: :nullify
  add_foreign_key "programacoes", "cinemas", name: "fk_cinema_id"
  add_foreign_key "programacoes", "importacoesprogs", column: "importacoesprog_id", name: "fk_importacoesprog_id"
  add_foreign_key "programacoes", "peliculas", name: "fk_pelicula_id"
  add_foreign_key "usuarios", "idiomas", name: "usuarios_ibfk_1"
  add_foreign_key "usuarios", "perfis", name: "usuarios_ibfk_2", on_delete: :cascade
  add_foreign_key "videos", "idiomas", name: "videos_ibfk_1", on_delete: :cascade
  add_foreign_key "webdoors", "idiomas", name: "webdoors_ibfk_1", on_delete: :cascade
end
