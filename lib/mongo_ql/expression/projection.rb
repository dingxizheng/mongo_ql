# frozen_string_literal: true

module MongoQL
  class Expression::Projection < Expression
    attr_accessor :field, :expression

    def initialize(field, expression = 1)
      @expression = case expression
                    when 0, 1
                      expression
                    when Expression::FieldNode
                      expression
                    else
                      raise ArgumentError, "#{expression&.inspect} is not a valid project expression"
                    end

      @field = case field
               when String, Symbol
                 Expression::FieldNode.new(field)
               when Expression::FieldNode
                 field
               else
                 raise ArgumentError, "#{field&.inspect} is not a valid project field"
               end
    end

    def to_ast
      { field.to_s => expression }
    end
  end
end