# frozen_string_literal: true

module MongoQL
  class Expression::MethodCall < Expression
    attr_accessor :target, :method, :args

    def initialize(target, method, **args)
      @target   = target
      @method   = method
      @args     = args
    end
  end
end