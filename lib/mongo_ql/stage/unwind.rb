# frozen_string_literal: true

module MongoQL
  class Stage::Unwind < Stage
    attr_accessor :ctx, :path, :allow_null

    def initialize(ctx, path, allow_null: false)
      @ctx        = ctx
      @path       = to_expression(path)
      @allow_null = allow_null
    end

    def to_ast
      ast = {
        "$unwind" => {
          "path" => path,
          "preserveNullAndEmptyArrays" => allow_null
        }
      }
      MongoQL::Utils.deep_transform_values(ast, &MongoQL::EXPRESSION_TO_AST_MAPPER)
    end
  end
end