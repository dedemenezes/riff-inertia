# frozen_string_literal: true

# Parses legacy HTML stored in `pagina.conteudo` for the Talents Programação
# page into sections grouped by day.
#
# Expected legacy structure:
#   <h3>DATE TITLE</h3>
#   <hr>
#   <p>...</p><ul>...</ul>...
#   <h3>NEXT DATE</h3>
#   ...
class TalentsProgramacaoParser
  class << self
    def parse(html)
      new(html).parse
    end
  end

  def initialize(html)
    @html = html.to_s
  end

  def parse
    return [] if @html.blank?

    fragment = Nokogiri::HTML::DocumentFragment.parse(@html)
    sections = []
    current = nil

    fragment.children.each do |node|
      next if node.text? && node.text.strip.empty?

      if node.element? && node.name == "h3"
        current = { titulo: node.text.strip, body_html: +"" }
        sections << current
      elsif node.element? && node.name == "hr"
        next
      elsif current
        current[:body_html] << node.to_html
      end
    end

    sections
  end
end
