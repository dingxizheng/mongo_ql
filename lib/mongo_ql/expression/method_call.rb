# frozen_string_literal: true

module MongoQL
  class Expression::MethodCall < Expression
    attr_accessor :method, :target, :ast_template, :args

    def initialize(method, target, ast_template:, **args)
      @target       = to_expression(target)
      @method       = method
      @ast_template = ast_template
      @args         = args
    end

    def to_ast
      { method => target.to_ast }
    end
  end
end