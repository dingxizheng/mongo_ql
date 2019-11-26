# frozen_string_literal: true

module MongoQL
  module CollectionOperators
    AGGREGATE_OPS = {
      "max":   "$max",
      "min":   "$min",
      "first": "$first",
      "last":  "$last",
      "sum":   "$sum",
      "avg":   "$avg",
      "size":  "$size",
      "push":  "$push",
      "reverse": "$reverseArray"
    }.freeze

    AGGREGATE_OPS.keys.each do |op|
      class_eval <<~RUBY
        def #{op}
          Expression::MethodCall.new(AGGREGATE_OPS[__method__], self)
        end
      RUBY
    end

    def filter(&block)
      evaled_cond = block.call(Expression::FieldNode.new("$item"))
      Expression::MethodCall.new "$filter", self, ast_template: -> (target, **_args) {
        {
          "input" => target,
          "as"    => "item",
          "cond"  => evaled_cond
        }
      }
    end

    def concat_arrays(*expressions)
      Expression::MethodCall.new "$concatArrays", self, ast_template: -> (target, **_args) {
        [target, *expressions]
      }
    end

    def combine_sets(*expressions)
      Expression::MethodCall.new "$setUnion", self, ast_template: -> (target, **_args) {
        [target, *expressions]
      }
    end

    def map(&block)
      evaled_in = block.call(Expression::FieldNode.new("$item"))
      Expression::MethodCall.new "$map", self, ast_template: -> (target, **_args) {
        {
          "input" => target,
          "as"    => "item",
          "in"    => evaled_in
        }
      }
    end

    def reduce(initial_value, &block)
      evaled_in = to_expression(block.call(Expression::FieldNode.new("$value"), Expression::FieldNode.new("$this")))
      Expression::MethodCall.new "$reduce", self, ast_template: -> (target, **_args) {
        {
          "input"        => target,
          "initialValue" => to_expression(initial_value),
          "in"           => evaled_in
        }
      }
    end

    def contains(ele)
      Expression::MethodCall.new "$in", self, ast_template: -> (target, **_args) {
        [to_expression(ele), target]
      }
    end
    alias_method :includes, :contains
    alias_method :include,  :contains
    alias_method :include?, :contains
    alias_method :includes?, :contains

    def any?(&block)
      if_null([]).filter(&block).size > 0
    end
  end
end