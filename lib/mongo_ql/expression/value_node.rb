# frozen_string_literal: true

module MongoQL
  class Expression::ValueNode < Expression
    attr_accessor :value

    def initialize(val)
      @value = val
    end

    def to_ast
      val
    end
  end
end