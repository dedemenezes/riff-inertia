class TipoSerializer
  def initialize(tipo, locale: I18n.locale)
    @tipo = tipo
    @locale = locale
  end

  def as_json
    {
      tipo_id: @tipo.id,
      tipo_nome: @locale == :pt ? @tipo.nome_pt : @tipo.nome_en
    }
  end
end
