# frozen_string_literal: true

module MongoQL
  class Expression::Binary < Expression
    attr_accessor :operator, :left_node, :right_node

    def initialize(operator, left, right)
      @operator   = operator
      @left_node  = to_expression(left)
      @right_node = to_expression(right)
    end

    def to_ast
      { operator => [left_node.to_ast, right_node.to_ast] }
    end
  end
end