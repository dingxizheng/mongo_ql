# frozen_string_literal: true

module MongoQL
  class Expression
    BINARY_OPS = {
      "+": "$add",
      "-": "$subtract",
      "*": "$multiply",
      "/": "$divide",
      ">": "$gt",
      "<": "$lt",
      ">=": "$gte",
      "<=": "$lte",
      "!=": "$ne",
      "==": "$eq",
      "&": "$and",
      "|": "$or",
      "%": "$mod",
      "**": "$pow"
    }.freeze

    UNARY_OPS = {
      "!": "$not"
    }.freeze

    def to_ast
      raise NotImplementedError, "#{self.class.name} must implement to_ast"
    end

    def to_expression(val)
      if val.is_a?(Expression)
        val
      else
        Expression::ValueNode.new(val)
      end
    end
  end
end