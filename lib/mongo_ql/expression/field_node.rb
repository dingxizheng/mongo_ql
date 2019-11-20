# frozen_string_literal: true

module MongoQL
  class Expression::FieldNode < Expression
    attr_accessor :field_name

    def initialize(name)
      @field_name = name
    end

    def method_missing(method_name, *args, &block)
      if args.size > 0 || block_given?
        raise NoMemoryError, "undefined method `#{method_name}' for #{self.class}"
      end
      Expression::FieldNode.new("#{field_name}.#{method_name}")
    end

    def f(field)
      Expression::FieldNode.new("#{field_name}.#{field}")
    end

    def to_ast
      "$#{field_name}"
    end

    def to_s
      field_name.to_s
    end

    def dsc
      Expression::Descend.new(self)
    end

    def asc
      Expression::Ascend.new(self)
    end
  end
end