# frozen_string_literal: true

require 'mongo'

require_relative 'parcel'

module Carrier
  module Service
    POINT_2_POINT = 'P2P'
    SHOP_2_SHOP = 'S2S'
    HOME_2_HOME = 'H2H'
  end

  module Name
    LIETUVOS_PASTAS = 'Lietuvos Pastas'
    DHL = 'DHL'
    UPS = 'UPS'
  end

  SAMPLE_DATA = [
    {
      _id: 1,
      name: 'Lietuvos Pastas',
      country_code: 'LT',
      website: 'https://lietuvospastas.lt',
      rates: [
        {
          _id: 1,
          name: 'LP-LOCKER-S',
          price: BSON::Decimal128.new('0.69'),
          currency_code: 'EUR',
          service: Service::POINT_2_POINT,
          delivery_duration_in_days: {
            from: 1,
            to: 3
          },
          parcel_size: Parcel::Size::SMALL,
          max_parcel_weight_in_kg: Parcel::Weight::SMALL,
          max_parcel_dimensions: Parcel::Dimensions::SMALL
        },
        {
          _id: 2,
          name: 'LP-LOCKER-M',
          price: BSON::Decimal128.new('1.55'),
          currency_code: 'EUR',
          service: Service::POINT_2_POINT,
          delivery_duration_in_days: {
            from: 1,
            to: 3
          },
          parcel_size: Parcel::Size::MEDIUM,
          max_parcel_weight_in_kg: Parcel::Weight::MEDIUM,
          max_parcel_dimensions: Parcel::Dimensions::MEDIUM
        },
        {
          _id: 3,
          name: 'LP-LOCKER-L',
          price: BSON::Decimal128.new('2.59'),
          currency_code: 'EUR',
          service: Service::POINT_2_POINT,
          delivery_duration_in_days: {
            from: 1,
            to: 3
          },
          parcel_size: Parcel::Size::LARGE,
          max_parcel_weight_in_kg: Parcel::Weight::LARGE,
          max_parcel_dimensions: Parcel::Dimensions::LARGE
        }
      ]
    },
    {
      _id: 2,
      name: 'DHL',
      country_code: 'DE',
      website: 'https://dhl.com',
      rates: [
        {
          _id: 4,
          name: 'DHL-SHOP-S',
          price: BSON::Decimal128.new('4.89'),
          currency_code: 'EUR',
          service: Service::SHOP_2_SHOP,
          delivery_duration_in_days: {
            from: 3,
            to: 5
          },
          parcel_size: Parcel::Size::SMALL,
          max_parcel_dimensions: Parcel::Dimensions::SMALL
        },
        {
          _id: 5,
          name: 'DHL-SHOP-M',
          price: BSON::Decimal128.new('8.89'),
          currency_code: 'EUR',
          service: Service::SHOP_2_SHOP,
          delivery_duration_in_days: {
            from: 3,
            to: 5
          },
          parcel_size: Parcel::Size::MEDIUM,
          max_parcel_dimensions: Parcel::Dimensions::MEDIUM
        },
        {
          _id: 6,
          name: 'DHL-SHOP-L',
          price: BSON::Decimal128.new('12.89'),
          currency_code: 'EUR',
          service: Service::SHOP_2_SHOP,
          delivery_duration_in_days: {
            from: 3,
            to: 5
          },
          parcel_size: Parcel::Size::LARGE,
          max_parcel_dimensions: Parcel::Dimensions::LARGE
        }
      ]
    },
    {
      _id: 3,
      name: 'UPS',
      country_code: 'US',
      website: 'https://ups.com',
      rates: [
        {
          _id: 7,
          name: 'UPS-HOME-S',
          price: BSON::Decimal128.new('12.45'),
          currency_code: 'USD',
          service: Service::HOME_2_HOME,
          delivery_duration_in_days: {
            from: 2,
            to: 5
          },
          parcel_size: Parcel::Size::SMALL,
          max_parcel_dimensions: Parcel::Dimensions::SMALL
        },
        {
          _id: 8,
          name: 'UPS-HOME-M',
          price: BSON::Decimal128.new('17.45'),
          currency_code: 'USD',
          service: Service::HOME_2_HOME,
          delivery_duration_in_days: {
            from: 2,
            to: 5
          },
          parcel_size: Parcel::Size::MEDIUM,
          max_parcel_dimensions: Parcel::Dimensions::MEDIUM
        },
        {
          _id: 9,
          name: 'UPS-HOME-L',
          price: BSON::Decimal128.new('24.25'),
          currency_code: 'USD',
          service: Service::HOME_2_HOME,
          delivery_duration_in_days: {
            from: 2,
            to: 5
          },
          parcel_size: Parcel::Size::LARGE,
          max_parcel_dimensions: Parcel::Dimensions::LARGE
        }
      ]
    }
  ].freeze
end
