# frozen_string_literal: true

require_relative "test_helper"

class TestMontoQL < Minitest::Test
  def setup
    @result_pipeline = [
      {"$lookup"  => {"from" => "customers", "as" => "customers", "localField" => "customer_id", "foreignField" => {"$toString" => {"$toObjectId" => "$_id"}}}},
      {"$lookup"  => {"from" => "shippings", "as" => "shippings", "pipeline" => [{"$match" => {"$expr" => {"$and" => [{"$eq" => ["$order_id", "$$var__id"]}, {"$eq" => ["$status", :shipped]}]}}}], "let" => {"var__id" => "$_id"}}},
      {"$match"   => {"$expr" => {"$eq" => ["$province", "ON"]}}},
      {"$project" => {"_id" => 1, "total" => 1, "customer" => "customers", "tax" => {"$multiply" => ["$total", "$tax_rate"]}}},
      {"$group"   => {"_id" => "$customer", "total" => {"$sum" => "$total"}, "total_tax" => {"$multiply" => [{"$sum" => "$tax"}, 5]}}},
      {"$sort"    => {"age" => -1}}
    ]
  end

  def test_compose
    pipeline = MongoQL.compose do
      join    customers,
              on: customer_id == _id.to_id,
              as: customers

      join    shippings, as: shippings do |doc|
        match  order_id == doc._id,
               status   == :shipped
      end

      match   province == "ON"

      project :_id,
              total,
              customer  => customers.name,
              tax       => total * tax_rate

      group   customer,
              total     => total.sum,
              total_tax => tax.sum * 5

      sort_by age.dsc
    end

    assert_equal pipeline.to_ast, @result_pipeline
  end
end