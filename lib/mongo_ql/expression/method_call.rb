# frozen_string_literal: true

module MongoQL
  class Expression::MethodCall < Expression
    attr_accessor :method, :target, :ast_template, :args

    def initialize(method, target, ast_template: nil, **args)
      @method       = method
      @args         = args
      @target       = to_expression(target)
      @ast_template = ast_template
    end

    def to_ast
      if ast_template
        { method => ast_template.call(target, **args) }
      else
        { method => target }
      end
    end
  end
end