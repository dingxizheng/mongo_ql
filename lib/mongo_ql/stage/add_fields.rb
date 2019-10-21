# frozen_string_literal: true

module MongoQL
  class Stage::AddFields < Stage
    attr_accessor :field_projections

    def initialize(*fields)
      @field_projections = fields.map do |field|
                              case field
                              when Hash
                                field.map { |k, v| [k.to_s, to_expression(v).to_ast] }.to_h
                              else
                                raise ArgumentError, "#{field} is not a valid field mapping option"
                              end
                            end.inject({}) { |p, c| p.merge(c) }
    end

    def to_ast
      { "$addFields" => field_projections }
    end

    protected
      def to_expression(val)
        if val.is_a?(Expression)
          val
        else
          Expression::ValueNode.new(val)
        end
      end
  end
end