# frozen_string_literal: true

module MongoQL
  class StageContext
    attr_accessor :pipeline

    def initialize
      @pipeline = []
    end

    def where(*args)
      pipeline << Stage::Match.new(*args)
    end
    alias_method :match, :where

    def add_fields(*args)
      raise NotImplementedError, "add_fields is not implemented"
    end

    def project(*fields)
      pipeline << Stage::Project.new(*fields)
    end
    alias_method :select, :project

    def lookup(*args, &block)
      pipeline << Stage::Lookup.new(*args, &block)
    end
    alias_method :join, :lookup

    def group(*args)
      pipeline << Stage::Group.new(*args)
    end

    def unwind(*args)
      pipeline << Stage::Unwind.new(*args)
    end
    alias_method :flatten, :unwind

    def sort(*args)
      pipeline << Stage::Sort.new(*args)
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

    def to_ast
      stages = pipeline.map(&:to_ast)
      stages.map do |stage|
        stage.deep_transform_values do |v|
          v.is_a?(Expression) ? v.to_ast : v
        end
      end
    end

    %w(where match project select sort flatten unwind lookup join).each do |m|
      alias_method :"#{m.capitalize}", m
    end
  end
end