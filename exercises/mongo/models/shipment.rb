# frozen_string_literal: true

require_relative 'address'

module Shipment
  module_function

  def sample_data(count)
    [
      generate_lt_data(count),
      generate_de_data(count),
      generate_us_data(count),
    ].reduce([], :+)
  end

  def generate_lt_data(count)
    generate_data(
      count,
      'Lietuvos Pastas',
      %w[LP-LOCKER-S LP-LOCKER-M LP-LOCKER-L]
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
      'DHL',
      %w[DHL-SHOP-S DHL-SHOP-M DHL-SHOP-L]
    )
  end

  def generate_us_data(count)
    generate_data(
      count,
      'UPS',
      %w[UPS-HOME-S UPS-HOME-M UPS-HOME-L]
    )
  end
end
