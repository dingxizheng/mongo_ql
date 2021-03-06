# frozen_string_literal: true

module MongoQL
  module DateOperators
    DATE_OPERATORS = {
      "year":         "$year",
      "week":         "$week",
      "month":        "$month",
      "day_of_month": "$dayOfMonth",
      "day_of_week":  "$dayOfWeek",
      "day_of_year":  "$dayOfYear",
      "iso_day_of_week": "$isoDayOfWeek",
      "iso_week":        "$isoWeek",
      "iso_week_Year":   "$isoWeekYear"
    }.freeze

    DATE_OPERATORS.keys.each do |op|
      class_eval <<~RUBY
        def #{op}
          Expression::MethodCall.new DATE_OPERATORS[__method__], self
        end
      RUBY
    end

    def format(format, timezone: nil)
      Expression::MethodCall.new "$dateToString", self, ast_template: -> (target, **_args) {
        if timezone
          {
            "format"   => format,
            "date"     => target,
            "timezone" => timezone
          }
        else
          {
            "format"   => format,
            "date"     => target
          }
        end
      }
    end
  end
end