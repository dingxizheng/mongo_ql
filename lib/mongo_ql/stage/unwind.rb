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
      {
        "$unwind" => {
          "path" => path.to_ast,
          "preserveNullAndEmptyArrays" => allow_null
        }
      }
    end
  end
end