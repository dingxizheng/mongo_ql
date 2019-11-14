# frozen_string_literal: true

module MongoQL
  class Expression::Switch < Expression
    class Branch < Expression
      attr_accessor :condition, :then_expr

      def initialize(condition, then_val = nil, **args, &block)
        @condition = condition
        @then_expr = then_val || args[:then]
        @then_expr = yield if block_given?
      end

      def then(then_val = nil, &block)
        @then_expr = then_val
        @then_expr = yield if block_given?
        self
      end
      alias_method :Then, :then

      def to_ast
        {
          "case" => condition,
          "then" => then_expr
        }
      end
    end

    attr_accessor :ctx, :branches, :default_expr

    def initialize(ctx, &block)
      @branches = []
      @ctx = ctx
      self.instance_exec(&block)
    end

    def cond(condition_expr, then_expr = nil, **args, &block)
      self.branches << Expression::Switch::Branch.new(condition_expr, then_expr, **args, &block)
    end
    alias_method :If, :cond

    def default(expr = nil, &block)
      @default_expr = expr
      @default_expr = yield if block_given?
    end
    alias_method :Default, :default

    def method_missing(m, *args, &block)
      ctx.send(m, *args, &block)
    end

    def to_ast
      {
        "$switch" => {
          "branches" => branches
        }.merge(default_expr.nil? ? {} : { "default" => default_expr })
      }
    end
  end
end