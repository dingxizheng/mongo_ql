# frozen_string_literal: true

module MongoQL
  class Stage::Lookup < Stage
    class NestedPipelineVars
      attr_accessor :vars

      def initialize
        @vars = {}
      end

      def method_missing(m, *args, &block)
        if is_setter?(m)
          set(m, args.first)
        else
          get(m)
        end
      end

      def get(name)
        vars["var_#{name}"] ||= Expression::FieldNode.new(name)
        Expression::FieldNode.new("$var_#{name}")
      end

      def set(name, val)
        vars["var_#{name}"] = val
      end

      private
        def is_setter?(method_name)
          method_name.to_s.end_with?("=")
        end
    end

    attr_accessor :from, :condition, :as, :nested_pipeline_block, :let_vars

    def initialize(from, condition = nil, on: nil, as: nil, &block)
      @from      = collection_name(from)
      @as        = new_array_name(as)
      @nested_pipeline_block = block

      if has_nested_pipeline?
        @let_vars = NestedPipelineVars.new
      else
        @condition = condition_ast(condition || on)
      end
    end

    def to_ast
      lookup_expr = { "from" => from, "as" => as }
      if has_nested_pipeline?
        lookup_expr["pipeline"] = nested_pipeline.to_ast
        lookup_expr["let"]      = let_vars.vars
      else
        lookup_expr = lookup_expr.merge(condition)
      end
      { "$lookup" => lookup_expr }
    end

    private
      def has_nested_pipeline?
        condition.nil? && !nested_pipeline_block.nil?
      end

      def nested_pipeline
        sub_ctx = StageContext.new
        sub_ctx.instance_exec(let_vars, &nested_pipeline_block)
        sub_ctx
      end

      def collection_name(from)
        case from
        when String, Symbol
          from
        when Expression::FieldNode
          from.to_s
        else
          if from&.respond_to?(:collection)
            from&.collection&.name
          elsif  from&.respond_to?(:name)
            from.name
          else
            raise ArgumentError, "#{from} is not a valid collection"
          end
        end
      end

      def condition_ast(cond)
        raise ArgumentError, "#{cond.inspect} must be a valid Expression::Binary, example: _id == user_id" unless cond.is_a?(Expression::Binary)
        raise ArgumentError, "#{cond.inspect} must be an 'equal' expression, example: _id == user_id" unless cond.operator == "$eq"
        {
          "localField"   => cond&.left_node&.to_s,
          "foreignField" => cond&.right_node&.to_s
        }
      end

      def new_array_name(as)
        as&.to_s
      end
  end
end