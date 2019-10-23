# frozen_string_literal: true

module MongoQL
  class Stage::Group < Stage
    EXPRESSION_TO_AST_MAPPER = proc { |v| v.is_a?(Expression) ? v.to_ast : v  }
    
    attr_accessor :ctx
    attr_accessor :by, :fields

    def initialize(ctx, by, arrow_fields = {}, **fields)
      @ctx    = ctx
      @by     = by
      @fields = fields.transform_keys(&:to_s).merge(arrow_fields.transform_keys(&:to_s))
    end

    def to_ast
      {
        "$group" => {
          "_id" => by.to_ast,
        }.merge(fields.deep_transform_values(&EXPRESSION_TO_AST_MAPPER))
      }
    end
  end
end