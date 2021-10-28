# frozen_string_literal: true

module Parcel
  module Size
    LARGE = 'L'
    MEDIUM = 'M'
    SMALL = 'S'
  end

  module Weight
    LARGE = 10
    MEDIUM = 5
    SMALL = 2
  end

  module Dimensions
    LARGE = { width: 350, length: 610, height: 365 }.freeze
    MEDIUM = { width: 350, length: 610, height: 175 }.freeze
    SMALL = { width: 350, length: 610, height: 80 }.freeze
  end
end
