# frozen_string_literal: true

module MongoQL
  class Stage::Match < Stage
    attr_accessor :ctx, :conditions, :field_filters

    def initialize(ctx, *conds, **field_filters)
      @ctx = ctx
      conds.each do |c|
        raise ArgumentError, "#{c.inspect} is not a valid MongoQL::Expression" unless c.is_a?(MongoQL::Expression)
      end
      @conditions    = conds
      @field_filters = field_filters
    end

    def to_ast
      conds = {}
      if compose_conditions
        conds["$expr"] = compose_conditions
      end
      ast = { "$match" => conds.merge(field_filters) }
      MongoQL::Utils.deep_transform_values(ast, &MongoQL::EXPRESSION_TO_AST_MAPPER)
    end

    private
      def compose_conditions
        if conditions.size > 1
          { "$and" => conditions }
        elsif conditions.size == 1
          conditions[0]
        else
          nil
        end
      end
  end
end