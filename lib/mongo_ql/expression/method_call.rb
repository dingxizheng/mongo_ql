# frozen_string_literal: true

module MongoQL
  class Expression::MethodCall < Expression
    attr_accessor :method, :target, :args

    def initialize(method, target, **args)
      @target   = to_expression(target)
      @method   = method
      @args     = args
    end

    def to_ast
      { method => target.to_ast }
    end
  end
end