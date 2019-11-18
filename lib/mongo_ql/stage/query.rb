# frozen_string_literal: true

module MongoQL
  class Stage::Query < Stage
    attr_accessor :collection_name

    def initialize(collection_name)
      @collection_name = collection_name
    end

    def to_ast
      {
        "$query" => @collection_name.to_s
      }
    end
  end
end