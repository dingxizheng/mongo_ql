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

    def self.register_method(method_name, operator, &block)
    end

    def filter(&block)
      Expression::MethodCall.new "$filter", self, ast_template: -> (target, **_args) {
        {
          "input" => target,
          "as"    => "item",
          "cond"  => block.call(Expression::FieldNode.new("$item")).to_ast
        }
      }
    end

    def map(&block)
      Expression::MethodCall.new "$map", self, ast_template: -> (target, **_args) {
        {
          "input" => target,
          "as"    => "item",
          "in"    => block.call(Expression::FieldNode.new("$item")).to_ast
        }
      }
    end

    def reduce(initial_value, &block)
      Expression::MethodCall.new "$reduce", self, ast_template: -> (target, **_args) {
        {
          "input"        => target,
          "initialValue" => to_expression(initial_value).to_ast,
          "in"           => to_expression(block.call(Expression::FieldNode.new("$value"), Expression::FieldNode.new("$this"))).to_ast
        }
      }
    end

    BINARY_OPS.keys.each do |op|
      class_eval <<~RUBY
        def #{op}(right_node)
          Expression::Binary.new(BINARY_OPS[__method__], self, right_node)
        end
      RUBY
    end

    UNARY_OPS.keys.each do |op|
      class_eval <<~RUBY
        def #{op}
          Expression::Unary.new(UNARY_OPS[__method__], self)
        end
      RUBY
    end

    def to_date
      Expression::MethodCall.new("$toDate", self)
    end

    def to_ast
      raise NotImplementedError, "#{self.class.name} must implement to_ast"
    end

    protected
      def to_expression(val)
        if val.is_a?(Expression)
          val
        else
          Expression::ValueNode.new(val)
        end
      end
  end
end

# Expression.register_method(:to_date, op: "$toDate") do |method, target, **args|
#   { input => target }
# end

# Expression.register_method(:map, op: "$toDate") do |method, target, **args|
#   { input => target }
# end

# items.map { this + 1 }

# val([ 1, 2, 3, 4 ]).reduce({ sum: 5, product: 2 }) do |product, item|
#   { sum: item.sum }
# end

# User.mongo_ql do
#   group name => user.name.first
# end