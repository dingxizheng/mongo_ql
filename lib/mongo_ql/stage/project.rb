# frozen_string_literal: true

module MongoQL
  class Stage::Project < Stage
    attr_accessor :ctx, :field_projections

    def initialize(ctx, *fields)
      @ctx = ctx
      @field_projections = fields.map do |field|
                              case field
                              when String, Symbol, Expression::FieldNode
                                { field.to_s => 1 }
                              when Hash
                                field.map { |k, v| [k.to_s, to_expression(v)] }.to_h
                              else
                                raise ArgumentError, "#{field} is not a valid field mapping option"
                              end
                            end.inject({}) { |p, c| p.merge(c) }
    end

    def to_ast
      ast = { "$project" => field_projections }
      MongoQL::Utils.deep_transform_values(ast, &MongoQL::EXPRESSION_TO_AST_MAPPER)
    end
  end
end