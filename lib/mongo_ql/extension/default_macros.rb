# frozen_string_literal: true

MongoQL::Macro.register(:current_date) do
  { "$toDate" => DateTime.now.to_date.iso8601 }
end

MongoQL::Macro.register(:current_time) do
  { "$toDate" => DateTime.now.iso8601 }
end