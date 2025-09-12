module TeamParseable
  extend ActiveSupport::Concern

  private

  def parse_team(field_value)
    return nil if field_value.blank?

    field_value.split(",").map(&:strip)
  end
end
