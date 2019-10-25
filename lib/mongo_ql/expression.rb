# frozen_string_literal: true

require_relative "binary_operators"
require_relative "unary_operators"
require_relative "collection_operators"
require_relative "string_operators"

module MongoQL
  class Expression
    include BinaryOperators
    include UnaryOperators
    include CollectionOperators
    include StringOperators

    FORMATING_OPS = {
      "to_object_id": "$toObjectId",
      "to_id":        "$toObjectId",
      "to_s":         "$toString",
      "to_string":    "$toString",
      "to_int":       "$toInt",
      "to_long":      "$toLong",
      "to_bool":      "$toBool",
      "to_date":      "$toDate",
      "to_decimal":   "$toDecimal",
      "to_double":    "$toDouble",
      "downcase":     "$toLower",
      "to_lower":     "$toLower",
      "upcase":       "$toUpper",
      "to_upper":     "$toUpper"
    }.freeze

    FORMATING_OPS.keys.each do |op|
      class_eval <<~RUBY
        def #{op}
          Expression::MethodCall.new(FORMATING_OPS[__method__], self)
        end
      RUBY
    end

    def type
      Expression::MethodCall.new "$type", self
    end

    def if_null(default_val)
      Expression::MethodCall.new "$ifNull", self, ast_template: -> (target, **_args) {
        [target, to_expression(default_val)]
      }
    end
    alias_method :default, :if_null

    def as_date
      Expression::DateNode.new(self)
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