# frozen_string_literal: true

module MongoQL
  class Expression::Macro < Expression
    attr_accessor :name

    def initialize(name)
      validate!(name)
      @name = name
    end

    def validate!(name)
      raise ArgumentError, "macro #{name} is not registered!" unless MongoQL::Macro.has_macro?(name)
    end

    def to_ast
      "$macro_#{name}"
    end
  end
end