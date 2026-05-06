class TalentsController < ApplicationController
  def participants
    @pagina = Pagina.find_by(rota: "/br/talents/", permalink: :apresentacao)

    render inertia: "Talents/Apresentacao", props: {
      pagina: @pagina,
      sections: TalentsContentParser.parse(@pagina&.conteudo),
      tabs: TalentsTabs.build(active: "sobre")
    }
  end
end
