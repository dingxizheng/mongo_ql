# frozen_string_literal: true

return unless defined?(Mongo::Criteria)

module MongoWhereExtension
  def where(*args, &block)
    if block_given?
      ctx    = AggregationOperationContext.new(:match)
      result = ctx.instance_exec(&block)
      if result.is_a?(AggregationExpression)
        super(result.expand_expression)
      elsif ctx.options
        super(ctx.options)
      else
        raise "where block must return a AggregationExpression"
      end
    else
      super(*args)
    end
  end
end

Mongoid::Criteria.prepend MongoWhereExtension