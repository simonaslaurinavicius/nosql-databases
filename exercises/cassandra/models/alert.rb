# frozen_string_literal: true

require_relative '../alerts/level'
require_relative '../alerts/details'

require 'faker'

class << (Alert = Object.new)
  include Alerts::Level
  include Alerts::Details

  ALERT_YEAR = 2021

  def generate(sensor_id, alert_count)
    Array.new(alert_count) do |_|
      {
        sensor_id: sensor_id
      }.merge(**level_data, **time_data)
    end
  end

  private

  def level_data
    level = [INFO, WARNING, ERROR].sample

    {
      level: level,
      details: details(level)
    }
  end

  def details(level)
    case level
    when INFO
      INFO_DETAILS
    when WARNING
      WARNING_DETAILS
    when ERROR
      ERROR_DETAILS
    end
  end

  def time_data
    month = Date.new(ALERT_YEAR, random_month)

    {
      month: month,
      alert_at: reading_at(month)
    }
  end

  def random_month
    [*(1..3)].sample
  end

  def reading_at(month)
    Faker::Time.between(
      from: month,
      to: month.next_month
    )
  end
end
