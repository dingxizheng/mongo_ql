
# Query DSL
```ruby
Order.where { tax != 0 }                          
#=> Order.where(tax: { "$ne": 0 })
Order.where { total >= 100 }                      
#=> Order.where(total: { "$gte": 100 })
Order.where { (total >= 100) & (total_tax < 15) } 
#=> Order.where({ "$and": [{ total: { "$gte": 100 }}, { total_tax: { "$lt": 15 }}]})
Order.where { tax > (shipping / 2) }              
#=> Order.where(tax: { "$gt": { "$divide": [ "$shipping", 2]}})
Order.where { total  >= If(currency == "CAD", 100, 80) }
#=> Order.where(total: { "$cond": { if: { "$eq": ["$currency", "CAD"]}, then: 100, else: 80 }})
```

# Aggregation Pipeline DSL
```ruby
Order.all.mongo_ql do
  join    Customer,
          on: customer_id == _id.to_id, 
          as: customers

  join    Shipping, :as => shippings do
    match  order_id == doc._id, 
           status   == :shipped
  end

  match   province == "ON"
  
  project :_id, 
          :total, 
          :customer  => customers.name,
          :tax       => total * tax_rate

  group   customer, 
          :total     => total.sum,
          :total_tax => tax.sum * 5

  sort_by age.desc

  page 1
  per  10
end

# The above aggregation is equivalent to the following mognodb pipeline
Order.collection.pipeline([
  { "$lookup":  {
    from:         "customers",
    localField:   "$customer_id",
    foreignField: "$_id",
    as:           "customers"
  }},
  { "$unwind":  {
    path:         "customers"
  }},
  { "$lookup":  {
    from:         "shippings",
    as:           "shippings",
    let:          { doc_id: "$_id" },
    pipeline:     [{
      "$match": {
        order_id: { "$eq": "$$dock_id" },
        status: :shipped  
      }
    }]
  }},
  { "$unwind":  {
    path:         "customers"
  }},
  { "$match":   {
    province:     { "$eq": "ON" }
  }},
  { "$project": {
    _id:          1,
    total:        1,
    customer:     "$customers.name",
    tax:          { "$multiply": ["$total", "$tax_rate"] }
  }},
  { "$group":   {
    _id:          "$customer",
    total:        { "$sum": "$total" },
    total_tax:    { "$multiply": [{ "$sum": "$tax" }, 5] }
  }}
])
```