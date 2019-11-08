# frozen_string_literal: true

module MongoQL
  class Expression::ValueNode < Expression
    SUPPORTED_TYPES = [
      String, Integer, Float,
      Array, Hash, TrueClass,
      FalseClass, Date, DateTime, Symbol,
      MongoQL::Expression::ValueNode
    ].freeze

    attr_accessor :value

    def initialize(val)
      Expression::ValueNode.valid!(val)
      @value = val
    end

    def to_ast
      case value
      when Date, DateTime
        Expression::ValueNode.new(value.iso8601).to_date.to_ast
      when MongoQL::Expression::ValueNode
        value.to_ast
      else
        value
      end
    end

    def self.valid?(value)
      SUPPORTED_TYPES.any? { |type| value.is_a?(type) }
    end

    def self.valid!(value)
      unless value.nil? || valid?(value)
        raise InvalidValueExpression, "#{value} must be in type #{SUPPORTED_TYPES.map(&:name).join(",")}"
      end
    end
  end
end