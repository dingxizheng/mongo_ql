# frozen_string_literal: true

module MongoQL
  class Stage::Group < Stage
    attr_accessor :ctx
    attr_accessor :by, :fields

    def initialize(ctx, by, *args, **fields)
      @ctx    = ctx
      @by     = by

      projection_fields = {}
      args.each do |arg|
        case arg
        when String, Symbol
          projection_fields.merge!(arg.to_s => Expression::FieldNode.new(arg).first)
        when Expression::FieldNode
          projection_fields.merge!(arg.to_s => arg.first)
        when Hash
          projection_fields.merge!(arg.transform_keys(&:to_s))
        end
      end

      @fields = fields.transform_keys(&:to_s).merge(projection_fields)
      # @fields = fields.transform_keys(&:to_s).merge(arrow_fields.transform_keys(&:to_s))
    end

    def to_ast
      ast = {
        "$group" => {
          "_id" => by,
        }.merge(fields)
      }
      MongoQL::Utils.deep_transform_values(ast, &MongoQL::EXPRESSION_TO_AST_MAPPER)
    end
  end
end