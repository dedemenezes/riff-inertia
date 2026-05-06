# frozen_string_literal: true

# Parses legacy HTML stored in `pagina.conteudo` for the Talents page into
# structured sections of participants, ready to feed JuriCard props.
#
# Expected legacy structure:
#   <h2>SectionTitle</h2>
#   <div class="row-fluid">
#     <div class="span4"><figure><img src="..." alt="..."></figure></div>
#     <div class="span8"><h3>Name</h3><p>Bio paragraph</p>...</div>
#   </div>
class TalentsContentParser
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
      next unless node.element?

      case node.name
      when "h2"
        current = { titulo: node.text.strip, participantes: [] }
        sections << current
      when "div"
        next unless node["class"]&.include?("row-fluid")
        next if current.nil?
        current[:participantes] << extract_participante(node)
      end
    end

    sections
  end

  private

  def extract_participante(node)
    {
      name: node.at_css("h3")&.text&.strip,
      photo: node.at_css("img")&.[]("src"),
      bio: node.css(".span8 p").map { |p| p.text.strip }.reject(&:blank?)
    }
  end
end
