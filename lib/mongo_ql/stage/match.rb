# frozen_string_literal: true

module MongoQL
  class Stage::Match < Stage
    attr_accessor :conditions, :field_filters

    def initialize(*conds, **field_filters)
      conds.each do |c|
        raise ArgumentError, "#{c.inspect} is not a MongoQL::Expression" unless c.is_a?(MongoQL::Expression)
      end
      @conditions    = conds
      @field_filters = field_filters
    end

    def to_ast
      conds = {}
      if conditions_ast
        conds["$expr"] = conditions_ast
      end
      { "$match" => conds.merge(field_filters) }
    end

    private
      def conditions_ast
        if conditions.size > 1
          { "$and": conditions.map(&:to_ast) }
        elsif conditions.size == 1
          conditions[0].to_ast
        else
          nil
        end
      end
  end
end