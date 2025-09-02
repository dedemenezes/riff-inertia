# config/initializers/inflections.rb

# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:

ActiveSupport::Inflector.inflections(:en) do |inflect|
  # Portuguese pluralization rules for your tables

  # Regular plurals that end in 's'
  inflect.irregular "alteracao", "alteracoes"
  inflect.irregular "edicao", "edicoes"
  inflect.irregular "importacao", "importacoes"
  inflect.irregular "programacao", "programacoes"

  # Words ending in 'a' that become 'as'
  inflect.irregular "pelicula", "peliculas"
  inflect.irregular "galeria", "galerias"
  inflect.irregular "noticia", "noticias"
  inflect.irregular "pagina", "paginas"

  # Words that don't change or are already plural
  inflect.uncountable %w[
    atores_peliculas
    paises_peliculas
    peliculas_tags
    importacao_convidados
    importacoesprogs
    mostras_bkp
  ]

  inflect.irregular "ator", "atores"
  inflect.irregular "pais", "paises"
  inflect.irregular "cinema", "cinemas"
  inflect.irregular "bairro", "bairros"
  inflect.irregular "caderno", "cadernos"
  inflect.irregular "clipping", "clippings"
  inflect.irregular "convidado", "convidados"
  inflect.irregular "destaque", "destaques"
  inflect.irregular "idioma", "idiomas"
  inflect.irregular "layout", "layouts"
  inflect.irregular "log", "logs"
  inflect.irregular "mostra", "mostras"
  inflect.irregular "newsletter", "newsletters"
  inflect.irregular "perfil", "perfis"
  inflect.irregular "tag", "tags"
  inflect.irregular "tipo", "tipos"
  inflect.irregular "torpedo", "torpedos"
  inflect.irregular "usuario", "usuarios"
  inflect.irregular "video", "videos"
  inflect.irregular "webdoor", "webdoors"
  inflect.irregular "cineencontro", "cineencontros"

  inflect.irregular "atores_pelicula", "atores_peliculas"
  inflect.irregular "paises_pelicula", "paises_peliculas"
  inflect.irregular "peliculas_tag", "peliculas_tags"
end
