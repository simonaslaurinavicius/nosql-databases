# frozen_string_literal: true

require_relative 'service'
require_relative 'models/carrier'
require_relative 'models/shipment'

def seed_db!
  seed_carriers!
  seed_shipments!
end

def seed_carriers!
  carriers = Service.mongo[:carriers]
  carriers.drop
  carriers.insert_many(Carrier::SAMPLE_DATA)
end

def seed_shipments!
  shipments = Service.mongo[:shipments]
  shipments.drop
  shipments.insert_many(Shipment.sample_data(30))
end
