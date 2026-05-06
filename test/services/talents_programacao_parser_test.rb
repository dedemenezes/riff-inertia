require "test_helper"

class TalentsProgramacaoParserTest < ActiveSupport::TestCase
  test "groups content by h3 headings" do
    html = <<~HTML
      <h3>DOMINGO, 5 DE OUTUBRO</h3><hr>
      <p><b>14:30 - Boas vindas</b></p>
      <ul><li>Pedro</li></ul>
      <h3>SEGUNDA-FEIRA, 6 DE OUTUBRO</h3><hr>
      <p><b>09:45 - Painel</b></p>
    HTML

    sections = TalentsProgramacaoParser.parse(html)

    assert_equal 2, sections.size
    assert_equal "DOMINGO, 5 DE OUTUBRO", sections[0][:titulo]
    assert_equal "SEGUNDA-FEIRA, 6 DE OUTUBRO", sections[1][:titulo]
  end

  test "section body_html preserves inner markup" do
    html = <<~HTML
      <h3>DIA 1</h3><hr>
      <p><b>10h</b> Atividade</p>
      <ul><li>Pessoa A</li><li>Pessoa B</li></ul>
    HTML

    body = TalentsProgramacaoParser.parse(html).first[:body_html]

    assert_includes body, "<p><b>10h</b> Atividade</p>"
    assert_includes body, "<li>Pessoa A</li>"
    assert_includes body, "<li>Pessoa B</li>"
    assert_includes body, "<ul"
  end

  test "skips hr separator between heading and body" do
    html = "<h3>DIA 1</h3><hr><p>conteudo</p>"

    body = TalentsProgramacaoParser.parse(html).first[:body_html]

    assert_not_includes body, "<hr"
    assert_includes body, "<p>conteudo</p>"
  end

  test "ignores content before any h3" do
    html = "<p>orfao</p><h3>DIA 1</h3><hr><p>real</p>"

    sections = TalentsProgramacaoParser.parse(html)

    assert_equal 1, sections.size
    assert_not_includes sections[0][:body_html], "orfao"
    assert_includes sections[0][:body_html], "real"
  end

  test "returns empty array for blank input" do
    assert_equal [], TalentsProgramacaoParser.parse(nil)
    assert_equal [], TalentsProgramacaoParser.parse("")
    assert_equal [], TalentsProgramacaoParser.parse("   ")
  end
end
