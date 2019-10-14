# frozen_string_literal: true

module MongoQL
  class Stage::Unwind < Stage
    attr_accessor :path, :allow_null

    def initialize(path, allow_null: false)
      @path       = path.is_a?(Expression) ? path.to_ast : path
      @allow_null = allow_null
    end

    def to_ast
      {
        "$unwind" => {
          "path" => path,
          "preserveNullAndEmptyArrays" => allow_null
        }
      }
    end
  end
end