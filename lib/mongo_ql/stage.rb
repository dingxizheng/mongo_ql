# frozen_string_literal: true

module MongoQL
  class Stage
    def to_ast
      raise NotImplementedError, "stage #{self.class} must implement to_ast"
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