# frozen_string_literal: true

module MongoQL
  module StringOperators
    def substr(start, length)
      Expression::MethodCall.new "$substr", self, ast_template: -> (target, **_args) {
        [target, to_expression(start).to_ast, to_expression(length).to_ast]
      }
    end

    def trim(chars)
      Expression::MethodCall.new "$trim", self, ast_template: -> (target, **_args) {
        {
          "input" => target,
          "chars" => to_expression(chars).to_ast
        }
      }
    end

    def concat(*expressions)
      Expression::MethodCall.new "$concat", self, ast_template: -> (target, **_args) {
        [target, *expressions.map { |e| to_expression(e) }.map(&:to_ast)]
      }
    end
  end
end