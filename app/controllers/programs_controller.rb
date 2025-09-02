class ProgramsController < ApplicationController
  def index
    text = I18n.t("hello")
    items = [
      # Links tem que vir do controller para incluir localizacao. Textos também
      { name: I18n.t("navigation.programming"), route: program_url, icon: "program" },
      { name: I18n.t("navigation.sessoes_com_convidados"), route: "/", icon: "user" },
      { name: I18n.t("navigation.mudancas_na_programacao"), route: "/", icon: "change" },
      { name: I18n.t("navigation.sessoes_ao_ar_livre"), route: "/", icon: "clock" }
    ]
    root_url = request.base_url
    render inertia: "ProgramPage", props: {
      text: text,
      items:,
      rootUrl: @root_url
    }
  end
end
