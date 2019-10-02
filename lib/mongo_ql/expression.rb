# frozen_string_literal: true

module MongoQL
  class Expression
    BINARY_OPS = {
      "+": "$add",
      "-": "$subtract",
      "*": "$multiply",
      "/": "$divide",
      ">": "$gt",
      "<": "$lt",
      ">=": "$gte",
      "<=": "$lte",
      "!=": "$ne",
      "==": "$eq",
      "&": "$and",
      "|": "$or",
      "%": "$mod",
      "**": "$pow"
    }.freeze

    UNARY_OPS = {
      "!": "$not"
    }.freeze

  end
end

# Expression.register_method(:date_to_string, "$dataToString") do |format: nil, timezone: nil, default: nil|
#   Expression::MethodCall.new(f, options: {})
# end