# frozen_string_literal: true

require 'faker'

module Address
  module_function

  def generate
    {
      name: Faker::Name.name,
      line1: Faker::Address.street_address,
      line2: [Faker::Address.secondary_address, nil].sample,
      city: Faker::Address.city,
      postal_code: Faker::Address.zip_code
    }.compact
  end
end
