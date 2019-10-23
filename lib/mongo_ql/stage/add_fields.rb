# frozen_string_literal: true

module MongoQL
  class Stage::AddFields < Stage
    attr_accessor :ctx
    attr_accessor :field_projections

    def initialize(ctx, *fields)
      @ctx = ctx
      @field_projections = fields.map do |field|
                              case field
                              when Hash
                                field.map { |k, v| [k.to_s, to_expression(v)] }.to_h
                              else
                                raise ArgumentError, "#{field} is not a valid field mapping option"
                              end
                            end.inject({}) { |p, c| p.merge(c) }
    end

    def to_ast
      { "$addFields" => field_projections }
    end
  end
end