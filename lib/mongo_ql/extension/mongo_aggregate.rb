# frozen_string_literal: true

return unless defined?(Mongo::Collection)
module Mongo
  class Collection
    alias_method :__old_aggregate__, :aggregate
    def aggregate(pipeline, options = {})
      expanded_pipeline = MongoQL::MacroProcessor.expand(pipeline)
      __old_aggregate__(expanded_pipeline, options)
    end
  end
end