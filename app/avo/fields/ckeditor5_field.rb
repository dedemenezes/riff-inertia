module Avo
  module Fields
    class Ckeditor5Field < BaseField
      def initialize(id, **args, &block)
        super(id, **args, &block)
        hide_on :index
      end
    end
  end
end
