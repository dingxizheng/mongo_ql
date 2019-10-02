# frozen_string_literal: true

module MongoQL
  class Expression::Binary < Expression
    attr_accessor :operator, :left_node, :right_node

    def initialize(operator, left, right)
      @operator   = operator
      @left_node  = left
      @right_node = right
    end
  end
end