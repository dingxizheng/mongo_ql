# frozen_string_literal: true

module MongoQL
  class Expression::Condition < Expression
    attr_accessor :condition, :then_expr, :else_expr

    def initialize(condition, then_val = nil, else_val = nil, &block)
      @condition = condition
      @then_expr = then_val
      @else_expr = else_val

      @then_expr = yield if !block.nil?
    end

    def then(then_val = nil, &block)
      @then_expr = then_val
      @then_expr = yield if !block.nil?
      self
    end
    alias_method :Then, :then

    def else(else_val = nil, &block)
      @else_expr = else_val
      @else_expr = yield if !block.nil?
      self
    end
    alias_method :Else, :else

    def to_ast
      {
        "$cond" => [condition, then_expr, else_expr]
      }
    end
  end
end