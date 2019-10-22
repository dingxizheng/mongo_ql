# frozen_string_literal: true

module MongoQL
  class Stage::Unwind < Stage
    attr_accessor :path, :allow_null

    def initialize(path, allow_null: false)
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