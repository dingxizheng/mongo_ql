# frozen_string_literal: true

module MongoQL
  class Expression::Unary < Expression
    attr_accessor :operator, :right_node

    def initialize(operator, right)
      @operator   = operator
      @right_node = right
    end
  end
end