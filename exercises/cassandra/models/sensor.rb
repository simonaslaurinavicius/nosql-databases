# frozen_string_literal: true

require_relative '../sensors/status'
require_relative '../sensors/type'

class << (Sensor = Object.new)
  include Sensors::Status
  include Sensors::Type

  def generate(sensor_count)
    sensor_data(sensor_count)
  end

  def generate_by_status(sensor_count)
    sensor_data(sensor_count).map do |data|
      data.merge(
        {
          status: [OK, MAITENANCE_NEEDED, OUT_OF_ORDER, STOPPED_MANUALLY].sample
        }
      )
    end
  end

  def generate_by_type(sensor_count)
    sensor_data(sensor_count).map do |data|
      data.merge(
        {
          type: [WIND_SPEED, TEMPERATURE].sample
        }
      )
    end
  end

  private

  def sensor_data(sensor_count)
    @sensor_data ||=
      Array.new(sensor_count) do |idx|
        {
          id: (idx + 1),
          turbine_id: [*(1..5)].sample
        }
      end
  end
end
