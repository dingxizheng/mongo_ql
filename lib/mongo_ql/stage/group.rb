# frozen_string_literal: true

module MongoQL
  class Stage::Group < Stage
    EXPRESSION_TO_AST_MAPPER = proc { |v| v.is_a?(Expression) ? v.to_ast : v  }

    attr_accessor :by, :fields

    def initialize(by, arrow_fields = {}, **fields)
      @by     = by
      @fields = fields.transform_keys(&:to_s).merge(arrow_fields.transform_keys(&:to_s))
    end

    def to_ast
      {
        "$group" => {
          "_id" => by.to_ast,
        }.merge(fields.transform_values(&EXPRESSION_TO_AST_MAPPER))
      }
    end
  end
end