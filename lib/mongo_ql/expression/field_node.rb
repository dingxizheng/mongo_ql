# frozen_string_literal: true

module MongoQL
  class Expression::FieldNode < Expression
    attr_accessor :field_name

    def initialize(name)
      @field_name = name
    end

    def method_missing(method_name, *args, &block)
      Expression::FieldNode.new("#{field_name}.#{method_name}")
    end

    def to_ast
      "$#{field_name}"
    end
  end
end