# frozen_string_literal: true

require_relative 'address'
require_relative 'carrier'

module Shipment
  module_function

  def sample_data(count)
    [
      generate_lt_data(count),
      generate_de_data(count),
      generate_us_data(count)
    ].reduce([], :+)
  end

  def generate_lt_data(count)
    generate_data(
      count,
      Carrier::Name::LIETUVOS_PASTAS,
      Carrier::Rates::LIETUVOS_PASTAS
    )
  end

  def generate_data(count, carrier_name, carrier_rate_name)
    Array.new(count) do
      base_shipment.merge(
        {
          carrier_name: carrier_name,
          carrier_rate_name: carrier_rate_name.sample
        }
      )
    end
  end

  def base_shipment
    {
      address_from: Address.generate,
      address_to: Address.generate,
      declared_value: declared_value
    }
  end

  def declared_value
    BSON::Decimal128.new(rand(5.0..45.0).round(2).to_s)
  end

  def generate_de_data(count)
    generate_data(
      count,
      Carrier::Name::DHL,
      Carrier::Rates::DHL
    )
  end

  def generate_us_data(count)
    generate_data(
      count,
      Carrier::Name::UPS,
      Carrier::Rates::UPS
    )
  end
end
