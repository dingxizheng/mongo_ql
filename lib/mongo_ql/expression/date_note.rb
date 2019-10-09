# frozen_string_literal: true

require_relative "../date_operators"

module MongoQL
  class Expression::DateNode < Expression
    include DateOperators

    attr_accessor :expression

    def initialize(expression)
      @expression = expression
    end

    def to_ast
      expression.to_ast
    end
  end
end