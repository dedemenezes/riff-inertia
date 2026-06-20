require "test_helper"

class JuriContentParserTest < ActiveSupport::TestCase
  HTML = <<~HTML
    <h3>PREMIERE BRASIL: COMPETIÇÃO PRINCIPAL</h3>
    <p><span style="font-size: 15px;"><b>Eric Lagesse - Presidente do Júri</b></span></p>
    <p></p><p></p>
    <p><img src="https://example.com/eric.jpg" style=""></p>
    <p></p>
    <p>Distribuidor, agente de vendas e produtor francês.</p>
    <p><b>Carolina Kotscho</b></p>
    <p><img src="https://example.com/carolina-kotscho.jpg" style=""></p>
    <p>Autora, diretora e produtora.</p>
    <p><b>Claudia Kopke</b></p>
    <h4><img src="https://example.com/claudia.jpg" style="background-color: initial;"></h4>
    <p>Figurinista premiada.</p>
    <p><b>Elena Manrique</b></p>
    <p><img src="https://example.com/elena.jpg" style=""></p>
    <p>Nasceu em Madri em 1965.</p>
    <p><b>Javier Garcia Puerto</b></p>
    <p><img src="https://example.com/javier.jpg" style=""></p>
    <p>Curador de cinema e vídeo.</p>
    <p><b>Luciana Bezerra</b></p>
    <p><img src="https://example.com/luciana.jpg" style=""></p>
    <p>Diretora, roteirista, atriz e sócia do Grupo Nós do Morro.</p>
    <p><b>Paula Astorga</b><br></p>
    <p><img src="https://example.com/paula.jpg" style=""></p>
    <p>Produtora e consultora de projetos audiovisuais.</p>
    <hr>
    <h3>PREMIÈRE BRASIL: NOVOS RUMOS</h3>
    <p><b style="background-color: initial;"></b></p>
    <p><b>Beth Formaggini - Presidenta do Júri</b><br></p>
    <p><img src="https://example.com/beth.jpg" style="background-color: initial;"></p>
    <p>Dirigiu os longas Memória para Uso Diário.</p>
    <p><b>Davi Pretto</b></p>
    <p><img src="https://example.com/davi.jpg" style=""></p>
    <p>Escreveu e dirigiu os longas Castanha.</p>
    <p><b>Lucas H. Rossi&nbsp;</b></p>
    <p><img src="https://example.com/lucas.jpg" style=""></p>
    <p>Realizador e produtor.</p>
    <p><b>Rafael Sampaio</b></p>
    <p><img src="https://example.com/rafael.jpg" style=""></p>
    <p>Produtor, curador e fundador.</p>
    <p><b>Thalita Carauta</b></p>
    <p><img src="https://example.com/thalita.jpg" style=""></p>
    <p>Atriz carioca.</p>
    <hr>
    <h3>PRÊMIO FELIX</h3>
    <p><b>Franck Finance-Madureira - Presidente</b></p>
    <h4><img src="https://example.com/franck.jpg" style="background-color: initial;"></h4>
    <p>Jornalista e crítico de cinema francês.</p>
    <p><b>Carolina Durão</b></p>
    <p><img src="https://example.com/carolina-durao.jpg" style=""></p>
    <p>Diretora Geral da série Rensga Hits!</p>
    <p><b>Chica Andrade</b></p>
    <p><b style="background-color: initial;"></b></p>
    <p><b style="background-color: initial;"><img src="https://example.com/chica.jpg" style="width: 770px;"></b></p>
    <p>Diretora, produtora e atriz.</p>
    <p><b>Hedu Carvalho (em drag, Dudakoo)</b></p>
    <h4><img src="https://example.com/hedu.jpg" style="background-color: initial;"></h4>
    <p>Idealizador do Cine Drag.</p>
  HTML

  test "parses ckeditor jury content into tabbed sections and jurors" do
    sections = JuriContentParser.parse(HTML)

    assert_equal 3, sections.size
    assert_equal "PREMIERE BRASIL: COMPETIÇÃO PRINCIPAL", sections[0][:title]
    assert_equal "Première Brasil", sections[0][:tab_label]
    assert_equal "premiere-brasil-competicao-principal", sections[0][:id]
    assert_equal 7, sections[0][:jurors].size
    assert_equal 5, sections[1][:jurors].size
    assert_equal 4, sections[2][:jurors].size
  end

  test "extracts name role photo and bio from confirmed ckeditor variations" do
    sections = JuriContentParser.parse(HTML)
    first = sections[0][:jurors].first
    claudia = sections[0][:jurors].third
    chica = sections[2][:jurors].third

    assert_equal "Eric Lagesse", first[:name]
    assert_equal "Presidente do Júri", first[:role]
    assert_equal "https://example.com/eric.jpg", first[:photo]
    assert_equal [ "Distribuidor, agente de vendas e produtor francês." ], first[:bio]

    assert_equal "Claudia Kopke", claudia[:name]
    assert_equal "https://example.com/claudia.jpg", claudia[:photo]
    assert_equal [ "Figurinista premiada." ], claudia[:bio]

    assert_equal "Chica Andrade", chica[:name]
    assert_equal "https://example.com/chica.jpg", chica[:photo]
    assert_equal [ "Diretora, produtora e atriz." ], chica[:bio]
  end

  test "ignores empty paragraphs empty bolds separators and inline styles" do
    sections = JuriContentParser.parse(HTML)

    assert_equal "Beth Formaggini", sections[1][:jurors].first[:name]
    assert_equal "Presidenta do Júri", sections[1][:jurors].first[:role]
    assert_equal "Lucas H. Rossi", sections[1][:jurors].third[:name]
    assert sections.all? { |section| section[:jurors].none? { |juror| juror[:name].blank? } }
  end

  test "removes script and style nodes before parsing" do
    html = <<~HTML
      <h3>PRÊMIO FELIX</h3>
      <script>alert("x")</script>
      <style>body { color: red; }</style>
      <p><b>Carolina Durão</b></p>
      <p><img src="https://example.com/carolina.jpg"></p>
      <p>Diretora Geral.</p>
    HTML

    juror = JuriContentParser.parse(html).first[:jurors].first

    assert_equal "Carolina Durão", juror[:name]
    assert_equal [ "Diretora Geral." ], juror[:bio]
  end

  test "returns empty array for blank input" do
    assert_equal [], JuriContentParser.parse(nil)
    assert_equal [], JuriContentParser.parse("")
    assert_equal [], JuriContentParser.parse("   ")
  end
end
