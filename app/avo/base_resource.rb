module Avo
  class BaseResource < Avo::Resources::Base
    self.find_record_method = -> {
      if model_class.column_names.include?("permalink")
        query.find_by!(permalink: id)
      else
        query.find(id)
      end
    }

    def field(id, **args, &block)
      args[:show_on] = :index if args[:as] == :textarea
      super(id, **args, &block)
    end
  end
end
