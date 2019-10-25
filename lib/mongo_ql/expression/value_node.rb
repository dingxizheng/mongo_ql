# frozen_string_literal: true

module MongoQL
  class Expression::ValueNode < Expression
    SUPPORTED_TYPES = [
      String, Integer, Float,
      Array, Hash, TrueClass,
      FalseClass, Date, Symbol,
      MongoQL::Expression::ValueNode
    ].freeze

    attr_accessor :value

    def initialize(val)
      Expression::ValueNode.valid!(val)
      @value = val
    end

    def to_ast
      value.is_a?(MongoQL::Expression::ValueNode) ? value.to_ast : v
    end

    def self.valid?(value)
      SUPPORTED_TYPES.any? { |type| value.is_a?(type) }
    end

    def self.valid!(value)
      unless valid?(value)
        raise InvalidValueExpression, "#{value} must be in type #{SUPPORTED_TYPES.map(&:name).join(",")}"
      end
    end
  end
end