require "test_helper"

class TalentsContentParserTest < ActiveSupport::TestCase
  test "groups participantes by h2 section" do
    html = <<~HTML
      <h2>Talents</h2>
      <div class="row-fluid">
        <div class="span4"><figure><img src="https://x/a.jpg" alt="A"></figure></div>
        <div class="span8"><h3>A Name</h3><p>A bio.</p></div>
      </div>
      <h2>Mentores</h2>
      <div class="row-fluid">
        <div class="span4"><figure><img src="https://x/b.jpg" alt="B"></figure></div>
        <div class="span8"><h3>B Name</h3><p>B bio.</p></div>
      </div>
    HTML

    sections = TalentsContentParser.parse(html)

    assert_equal 2, sections.size
    assert_equal "Talents", sections[0][:titulo]
    assert_equal 1, sections[0][:participantes].size
    assert_equal "A Name", sections[0][:participantes].first[:name]
    assert_equal "https://x/a.jpg", sections[0][:participantes].first[:photo]
    assert_equal [ "A bio." ], sections[0][:participantes].first[:bio]
    assert_equal "Mentores", sections[1][:titulo]
  end

  test "collects multiple bio paragraphs into array" do
    html = <<~HTML
      <h2>Talents</h2>
      <div class="row-fluid">
        <div class="span4"><figure><img src="https://x/h.jpg" alt="H"></figure></div>
        <div class="span8"><h3>H Name</h3><p>Para 1.</p><p>Para 2.</p><p>Para 3.</p></div>
      </div>
    HTML

    sections = TalentsContentParser.parse(html)
    bio = sections[0][:participantes].first[:bio]

    assert_equal [ "Para 1.", "Para 2.", "Para 3." ], bio
  end

  test "ignores hr separators between row-fluid blocks" do
    html = <<~HTML
      <h2>Talents</h2>
      <div class="row-fluid"><div class="span4"><figure><img src="https://x/a.jpg"></figure></div><div class="span8"><h3>A</h3><p>x</p></div></div>
      <hr />
      <div class="row-fluid"><div class="span4"><figure><img src="https://x/b.jpg"></figure></div><div class="span8"><h3>B</h3><p>y</p></div></div>
    HTML

    sections = TalentsContentParser.parse(html)

    assert_equal 2, sections[0][:participantes].size
  end

  test "drops blank paragraphs from bio" do
    html = <<~HTML
      <h2>Talents</h2>
      <div class="row-fluid">
        <div class="span4"><figure><img src="https://x/a.jpg"></figure></div>
        <div class="span8"><h3>A</h3><p>real bio</p><p>   </p><p></p></div>
      </div>
    HTML

    sections = TalentsContentParser.parse(html)

    assert_equal [ "real bio" ], sections[0][:participantes].first[:bio]
  end

  test "ignores row-fluid before any h2" do
    html = <<~HTML
      <div class="row-fluid">
        <div class="span4"><figure><img src="https://x/a.jpg"></figure></div>
        <div class="span8"><h3>Orphan</h3><p>x</p></div>
      </div>
      <h2>Talents</h2>
      <div class="row-fluid">
        <div class="span4"><figure><img src="https://x/b.jpg"></figure></div>
        <div class="span8"><h3>B</h3><p>y</p></div>
      </div>
    HTML

    sections = TalentsContentParser.parse(html)

    assert_equal 1, sections.size
    assert_equal "B", sections[0][:participantes].first[:name]
  end

  test "returns empty array for blank input" do
    assert_equal [], TalentsContentParser.parse(nil)
    assert_equal [], TalentsContentParser.parse("")
    assert_equal [], TalentsContentParser.parse("   ")
  end
end
