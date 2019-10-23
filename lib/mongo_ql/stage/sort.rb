# frozen_string_literal: true

module MongoQL
  class Stage::Sort < Stage
    attr_accessor :ctx, :fields

    def initialize(ctx, *fields)
      @ctx = ctx
      @fields = fields.map do |field|
        case field
        when Expression::FieldNode
          field.asc
        when String, Symbol
          Expression::FieldNode.new(field).asc
        when Expression::Ascend, Expression::Descend
          field
        else
          raise ArgumentError, "#{field.inspect} must be in type [String, Symbol, Expression::FieldNode, Expression::Ascend, Expression::Descend]"
        end
      end
    end

    def to_ast
      {
        "$sort" => fields.inject({}) { |p, c| p.merge(c.to_ast) }
      }
    end
  end
end