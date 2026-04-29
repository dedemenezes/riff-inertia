class DestaqueSerializer
  def initialize(destaque)
    @destaque = destaque
  end

  def as_json
    {
      id: @destaque.id,
      titulo: @destaque.titulo,
      url: @destaque.url,
      destino: @destaque.destino,
      imagem: @destaque.image_url
    }
  end
end
