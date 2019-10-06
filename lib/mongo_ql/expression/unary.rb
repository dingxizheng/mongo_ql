# frozen_string_literal: true

module MongoQL
  class Expression::Unary < Expression
    attr_accessor :operator, :right_node

    def initialize(operator, right)
      @operator   = operator
      @right_node = to_expression(right)
    end

    def to_ast
      { operator => right_node.to_ast }
    end
  end
end