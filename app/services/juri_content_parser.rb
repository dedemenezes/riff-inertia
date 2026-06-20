# frozen_string_literal: true

# Parses legacy CKEditor HTML from the current Jury page into sections and
# jurors that can be rendered as Figma-style tabs/cards.
class JuriContentParser
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
    fragment.css("script, style").remove

    @sections = []
    @current_section = nil
    @current_juror = nil

    fragment.children.each do |node|
      next unless node.element?

      if section_heading?(node)
        start_section(node)
      elsif @current_section
        parse_section_node(node)
      end
    end

    finish_current_juror
    @sections
  end

  private

  def parse_section_node(node)
    return if node.name == "hr"

    if juror_name_node?(node)
      start_juror(extract_juror_name(node))
      return
    end

    return unless @current_juror

    if @current_juror[:photo].blank? && (image = node.at_css("img"))
      @current_juror[:photo] = image["src"].to_s
      return
    end

    append_bio(node) if @current_juror[:photo].present?
  end

  def section_heading?(node)
    node.name == "h3" && node.text.strip.present?
  end

  def start_section(node)
    finish_current_juror

    title = normalize_text(node.text)
    @current_section = {
      id: title.parameterize,
      title: title,
      tab_label: tab_label_for(title),
      jurors: []
    }
    @sections << @current_section
  end

  def start_juror(raw_name)
    finish_current_juror

    name, role = raw_name.split(/\s+-\s+/, 2).map { |part| normalize_text(part) }
    @current_juror = {
      name: name,
      role: role.to_s,
      photo: "",
      bio: []
    }
  end

  def finish_current_juror
    return unless @current_section && @current_juror
    return if @current_juror[:name].blank?

    @current_section[:jurors] << @current_juror
    @current_juror = nil
  end

  def juror_name_node?(node)
    return false unless %w[p h4].include?(node.name)

    bold = first_textual_bold(node)
    return false unless bold

    bold_text = normalize_text(bold.text)
    node_text = normalize_text(node.text)
    bold_text.present? && node_text == bold_text
  end

  def first_textual_bold(node)
    node.css("b, strong").find { |bold| normalize_text(bold.text).present? }
  end

  def extract_juror_name(node)
    normalize_text(first_textual_bold(node).text)
  end

  def append_bio(node)
    return unless node.name == "p"
    return if node.at_css("img")

    text = normalize_text(node.text)
    @current_juror[:bio] << text if text.present?
  end

  def normalize_text(text)
    text.to_s.gsub(/\u00a0/, " ").squish
  end

  def tab_label_for(title)
    normalized = ActiveSupport::Inflector.transliterate(title).downcase

    case normalized
    when /novos rumos/
      "Novos Rumos"
    when /premio felix/
      "Prêmio Félix"
    when /premiere brasil/
      "Première Brasil"
    else
      title.titleize
    end
  end
end
