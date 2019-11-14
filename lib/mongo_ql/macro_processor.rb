
# frozen_string_literal: true

module MongoQL
  class MacroProcessor
    class << self
      def expand(pipeline = [])
        MongoQL::Utils.deep_transform_values(pipeline) do |value|
          case value
          when String
            if value.start_with?("$macro_")
              MongoQL::Macro.eval(value[7..-1])
            else
              value
            end
          else
            value
          end
        end
      end
    end
  end
end