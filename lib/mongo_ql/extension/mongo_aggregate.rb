# frozen_string_literal: true

module MongoQL
  module MongoAggregate
    def aggregate(pipeline, options = {})
      expanded_pipeline = MongoQL::MacroProcessor.expand(pipeline)
      super(expanded_pipeline, options)
    end
  end
end

if defined?(Mongo::Database::View)
  Mongo::Database::View.prepend MongoQL::MongoAggregate
end