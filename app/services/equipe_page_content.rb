# frozen_string_literal: true

# Static copy for the Equipe page (Figma: Equipe frame). Replace with API/CMS when available.
class EquipePageContent
  STANDARD_PROGRAMMING_BLOCKS = [
    { title: "Coordenação / Coordination", names: [ "Pedro Carneiro" ] },
    { title: "Coordenação Assistente", names: [ "Daniela Zanúncio" ] },
    {
      title: "Eventos e Convidados Internacionais / International Events and Guests",
      names: [ "Beatriz Costa" ]
    },
    {
      title: "Assistentes de Coordenação Internacional / International Coordination Assistants",
      names: [ "Maria Luísa Sena", " João Pedro Santos" ]
    },
    {
      title: "Coordenação de Programação (Cinemas e Bilheteria) / Screening Schedule",
      names: [ "Guilherme Tristão" ]
    },
    { title: "Assistente", names: [ "Alice Ripper" ] },
    { title: "Colaboração / Collaboration", names: [ "Luiz Eduardo Pereira de Souza" ] },
    {
      title: "Curadoria Itinerários Únicos / Curator Unique Itineraries",
      names: [ "Rodrigo Cardoso" ]
    }
  ].freeze

  INTRO_BLOCKS = [
    {
      title: "Conselho Diretor / Steering Committee",
      names: [
        "Ilda Santiago",
        "Marcos Didonet",
        "Nelson Krumholz",
        "Vilma Lustosa",
        "Walkiria Barbosa"
      ]
    },
    {
      title: "Comissão de Seleção / Programming Committee",
      names: [
        "Ilda Santiago",
        "Pedro Carneiro",
        "Daniela Zanúncio",
        "Guilherme Tristão",
        "Rodrigo Cardoso",
        "Ricardo Cota"
      ]
    },
    {
      title: "Comissão de Seleção Première Brasil Longas / Première Brasil Programming Committee",
      names: [
        "Ilda Santiago",
        "Karen Black",
        "Flavia Candida",
        "Julia Couto",
        "Ricardo Cota",
        "Ana Clara Taunay"
      ]
    },
    {
      title: "Comissão de Seleção Première Brasil Curtas / Première Brasil Shorts Programming Committee",
      names: [
        "Ilda Santiago",
        "Karen Black",
        "Flavia Candida",
        "Julia Couto",
        "Ricardo Cota",
        "Ana Clara Taunay"
      ]
    },
    {
      title: "Direção Executiva / Executive Directors",
      names: [
        "Ilda Santiago",
        "Walkiria Barbosa"
      ]
    },
    { title: "Direção de Programação / Programming Director", names: [ "Ilda Santiago" ] },
    {
      title: "Direção de Comunicação e Marketing / Communications and Marketing Director",
      names: [ "Vilma Lustosa" ]
    },
    {
      title: "Direção Administrativo-Financeira / Managing Director",
      names: [ "Nelson Krumholz" ]
    },
    {
      title: "Direção de Projetos Especiais / Special Projects Director",
      names: [ "Marcos Didonet" ]
    },
    {
      title: "Assistentes de Direção / Assistant Directors",
      names: [
        "Giselia Martins",
        "Anita Barbosa",
        "Irina Neves",
        "Frederico Santiago",
        "Barbara Padovani"
      ]
    }
  ].freeze

  SECTION_TITLES = [
    "Programação Internacional / International Programming",
    "Mostra Première Brasil / Première Brasil Programme",
    "Programa Geração / Generation Program",
    "Cinema Circulação",
    "Cinema Circulação",
    "RioMarket",
    "Sede do Festival",
    "Comunicação e Marketing"
  ].freeze

  def self.as_props
    {
      intro_blocks: INTRO_BLOCKS,
      sections: SECTION_TITLES.map { |title| { title: title, blocks: STANDARD_PROGRAMMING_BLOCKS } }
    }
  end
end
