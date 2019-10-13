# frozen_string_literal: true

module MongoQL
  class Stage::Lookup < Stage
    attr_accessor :from, :condition, :as, :nested_pipeline_block

    def initialize(from, condition = nil, on: nil, as: nil, &block)
      @from      = from
      @condition = condition || on
      @as        = as
      @nested_pipeline_block = block
    end

    def to_ast
      { "$lookup" =>  0 }
    end

    private
      def has_nested_pipeline?
        condition.nil? && nested_pipeline_block.present?
      end

      def nested_pipeline
        sub_ctx = StageContext.new
        sub_ctx.instance_exec(&nested_pipeline_block)
      end
  end
end