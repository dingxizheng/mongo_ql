
# frozen_string_literal: true

require_relative "../test_helper"

class TestUtils < Minitest::Test
  def setup
    @value = {
      "name": "Tester",
      "age":  48,
      "children": [
        "Lili",
        {
          "name": "Boby",
          "age":  15,
        },
        3
      ]
    }

    @trasformed_value = {
      "name": "Tester",
      "age":  "48",
      "children": [
        "Lili",
        {
          "name": "Boby",
          "age":  "15",
        },
        {
          "name": "Third",
          "age":  "10",
        }
      ]
    }
  end

  def test_deep_transform_values
    result = MongoQL::Utils.deep_transform_values(@value) do |v|
              case v
              when 3
                { "name": "Third", "age":  10 }
              when Integer
                v.to_s
              else
                v
              end
            end
    assert_equal result, @trasformed_value
  end
end