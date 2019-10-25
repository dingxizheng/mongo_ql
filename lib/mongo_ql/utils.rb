# frozen_string_literal: true
module MongoQL
  class Utils
    class << self
      def deep_transform_values(value, &block)
        case value
        when Hash
          value.transform_values do |val|
            MongoQL::Utils.deep_transform_values(val, &block)
          end
        when Array
          value.map do |val|
            MongoQL::Utils.deep_transform_values(val, &block)
          end
        else
          transformed_value = yield(value)
          case transformed_value
          when Hash
            MongoQL::Utils.deep_transform_values(transformed_value, &block)
          when Array
            MongoQL::Utils.deep_transform_values(transformed_value, &block)
          else
            transformed_value
          end
        end
      end
    end
  end
end