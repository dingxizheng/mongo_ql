# frozen_string_literal: true

module MongoQL
  class Expression::MethodCall < Expression
    attr_accessor :method, :target, :ast_template, :args

    def initialize(method, target, ast_template: nil, **args)
      @target       = to_expression(target)
      @method       = method
      @ast_template = ast_template
      @args         = args
    end

    def to_ast
      if ast_template
        { method => ast_template.call(target.to_ast, **args) }
      else
        { method => target.to_ast }
      end
    end
  end
end