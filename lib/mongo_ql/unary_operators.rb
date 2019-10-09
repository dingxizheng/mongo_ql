# frozen_string_literal: true

module MongoQL
  module UnaryOperators
    UNARY_OPS = {
      "!": "$not"
    }.freeze

    UNARY_OPS.keys.each do |op|
      class_eval <<~RUBY
        def #{op}
          Expression::Unary.new(UNARY_OPS[__method__], self)
        end
      RUBY
    end
  end
end