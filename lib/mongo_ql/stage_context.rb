# frozen_string_literal: true

module MongoQL
  class StageContext
    attr_accessor :pipeline, :injected_vars

    def initialize
      @pipeline = []
      @injected_vars = {}
    end

    def scope(mongo_scope)
      criteria = nil
      if mongo_scope.respond_to?(:all)
        criteria = mongo_scope.all.selector.transform_keys { |k| k.to_sym }
      end

      if mongo_scope.is_a?(Hash)
        criteria = mongo_scope.transform_keys { |k| k.to_sym }
      end
      where(**criteria) if criteria
    end

    def where(*args)
      pipeline << Stage::Match.new(self, *args)
    end
    alias_method :match, :where

    def add_fields(*args)
      pipeline << Stage::AddFields.new(self, *args)
    end

    def project(*fields)
      pipeline << Stage::Project.new(self, *fields)
    end
    alias_method :select, :project

    def lookup(*args, &block)
      pipeline << Stage::Lookup.new(self, *args, &block)
    end
    alias_method :join, :lookup

    def group(*args)
      pipeline << Stage::Group.new(self, *args)
    end

    def unwind(*args)
      pipeline << Stage::Unwind.new(self, *args)
    end
    alias_method :flatten, :unwind

    def sort(*args)
      pipeline << Stage::Sort.new(self, *args)
    end
    alias_method :sort_by, :sort

    def method_missing(m, *args, &block)
      Expression::FieldNode.new(m)
    end

    def first_of(*field_expressions)
      field_expressions.map do |expr|
        [expr, expr.first]
      end.to_h
    end

    def f(name)
      Expression::FieldNode.new(name)
    end

    def v(val)
      Expression::ValueNode.new(val)
    end

    def cond(conditon_expr, then_expr = nil, else_expr = nil, &block)
      Expression::Condition.new(conditon_expr, then_expr, else_expr, &block)
    end
    alias_method :If, :cond

    def to_ast
      pipeline.map(&:to_ast)
    end

    %w(scope where match project select sort flatten unwind lookup join).each do |m|
      alias_method :"#{m.capitalize}", m
    end
  end
end