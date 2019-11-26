# frozen_string_literal: true

module MongoQL
  class Stage::Limit < Stage
    attr_accessor :ctx, :number

    def initialize(ctx, number)
      @ctx = ctx
      @number = number
    end

    def to_ast
      {
        "$limit" => number
      }
    end
  end
end