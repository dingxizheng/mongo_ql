# MongoQL
[![Gem](https://img.shields.io/gem/v/mongo_ql.svg?style=flat)](http://rubygems.org/gems/mongo_ql "View this project in Rubygems")
[![Actions Status](https://github.com/dingxizheng/mongo_ql/workflows/Ruby/badge.svg)](https://github.com/dingxizheng/mongo_ql/actions)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

## Installation
Install from RubyGems by adding it to your `Gemfile`, then bundling.

```ruby
# Gemfile
gem 'mongo_ql'
```

```
$ bundle install
```

## Aggregation Pipeline DSL
```ruby
MongoQL.compose do
  lookup  customers,
          on: customer_id == _id.to_id, 
          as: customers

  lookup  shippings, :as => shippings do |doc|
    match  order_id == doc._id, 
           status   == :shipped
  end

  where   province == "ON",
          discounts.any? { |d| d.price > 6 }
  
  project _id, 
          total, 
          customer  => customers.name,
          tax       => total * tax_rate,
          status    => If price <= 10, "Not Bad", "Good"

  group   customer, 
          total     => total.sum,
          total_tax => tax.sum * 5

  sort    age.dsc
end
```

## The above aggregation DSL generates the following MongoDB pipeline
```json
[{
  "$lookup": {
    "from": "customers",
    "as": "customers",
    "localField": "customer_id",
    "foreignField": {
      "$toString": {
        "$toObjectId": "$_id"
      }
    }
  }
}, {
  "$lookup": {
    "from": "shippings",
    "as": "shippings",
    "pipeline": [{
      "$match": {
        "$expr": {
          "$and": [{
            "$eq": ["$order_id", "$$var__id"]
          }, {
            "$eq": ["$status", "shipped"]
          }]
        }
      }
    }],
    "let": {
      "var__id": "$_id"
    }
  }
}, {
  "$match": {
    "$expr": {
      "$eq": ["$province", "ON"]
    }
  }
}, {
  "$project": {
    "_id": 1,
    "total": 1,
    "customer": "customers",
    "tax": {
      "$multiply": ["$total", "$tax_rate"]
    }
  }
}, {
  "$group": {
    "_id": "$customer",
    "total": {
      "$sum": "$total"
    },
    "total_tax": {
      "$multiply": [{
        "$sum": "$tax"
      }, 5]
    }
  }
}, {
  "$sort": {
    "age": -1
  }
}]
```