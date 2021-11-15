# frozen_string_literal: true

require 'faker'
require 'date'

class << (Reading = Object.new)
  READING_YEAR = 2021
  READING_MONTH = 1

  def generate(sensor_id, reading_count)
    Array.new(reading_count) do |_idx|
      {
        sensor_id: sensor_id,
        data: Faker::Number.between(from: 1.0, to: 45.0)
      }.merge(time_data)
    end
  end

  private

  def time_data
    day = Date.new(READING_YEAR, READING_MONTH, random_day)

    {
      day: day,
      reading_at: reading_at(day)
    }
  end

  def random_day
    [*(1..7)].sample
  end

  def reading_at(day)
    Faker::Time.between(
      from: day,
      to: day.next_day
    )
  end
end
