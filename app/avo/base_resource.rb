module Avo
  class BaseResource < Avo::Resources::Base
    self.find_record_method = -> {
      if model_class.column_names.include?("permalink")
        query.find_by!(permalink: id)
      else
        query.find(id)
      end
    }
  end
end
