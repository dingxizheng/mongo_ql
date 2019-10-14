# frozen_string_literal: true

module MongoQL
  class Expression::Descend < Expression
    attr_accessor :field

    def initialize(field)
      @field = field
    end

    def to_ast
      { field.to_s => -1 }
    end
  end
end