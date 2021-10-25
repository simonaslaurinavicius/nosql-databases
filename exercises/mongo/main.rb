#!/usr/bin/env ruby
# frozen_string_literal: true

=begin
  Shipping carrier aggregator queries - solution to an
  exercise designed to gain experience with document databases.

  Database used - MongoDB

  Author: Simonas Laurinavicius
  Course: Non relational databases (NoSQL)
  Study program, year, group: Informatics, 4, 1
  Email: simonas.laurinavicius@mif.stud.vu.lt
  Last updated: 2021-10-25
=end

require 'mongo'

require_relative 'service'

def find_rates
  rates = carriers.find({}, { _id: 0, rates: 1 })

  rates.each do |doc|
    doc[:rates].each do |rate|
      puts rate
    end
  end
end

def carriers
  @carriers ||= Service.mongo[:carriers]
end

def aggregate_rates
  query = [
    { '$unwind' => '$rates' },
    { '$project' => { _id: 0, rates: 1 } }
  ]

  carriers.aggregate(query).each { |doc| puts doc }
end

def declared_value_avg(carrier_name)
  query = [
    {
      '$match' => { carrier_name: carrier_name }
    },
    {
      '$group' => {
        _id: '$carrier_rate_name',
        declared_value_average: { '$avg' => '$declared_value' }
      }
    }
  ]

  shipments.aggregate(query).each { |doc| puts doc }
end

def shipments
  @shipments ||= Service.mongo[:shipments]
end

# Because MapReduce doesn't support arithmetic with Decimal128 type used
# for declared_value field, coming up with different query to test aforementioned
# functionality - counting how many shipments are there for carrier rates
def rate_shipment_count(carrier_name)
  map = 'function map() {  emit(this.carrier_rate_name, this._id) }'
  reduce = 'function reduce(key, values) { return values.length }'
  query = { query: { carrier_name: 'UPS' } }

  shipments_view.map_reduce(map, reduce, query).each { |doc| puts doc }
end

def shipments_view
  Mongo::Collection::View.new(shipments)
end


find_rates
aggregate_rates
declared_value_avg('UPS')
rate_shipment_count('DHL')
