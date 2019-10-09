# frozen_string_literal: true

module MongoQL
  module CollectionOperators
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
  end
end