# frozen_string_literal: true

require_relative '../service'
require_relative '../models/sensor'
require_relative '../models/reading'
require_relative '../models/alert'

SENSOR_COUNT = 20
READING_COUNT = 50
ALERT_COUNT = 5

def seed_db!
  truncate!
  seed_sensors!
  seed_sensor_readings!
  seed_sensor_alerts!
end

def truncate!
  Service.cassandra.execute('TRUNCATE sensors')
  Service.cassandra.execute('TRUNCATE sensors_by_status')
  Service.cassandra.execute('TRUNCATE sensors_by_type')
  Service.cassandra.execute('TRUNCATE day_readings_by_sensor')
  Service.cassandra.execute('TRUNCATE month_alerts_by_sensor')
end

def seed_sensors!
  seed_generic_sensors!
  seed_sensors_by_status!
  seed_sensors_by_type!
end

def seed_generic_sensors!
  sensors.each do |data|
    Service.cassandra.execute(sensors_statement.bind(data))
  end
end

def sensors
  Sensor.generate(SENSOR_COUNT)
end

def sensors_statement
  @sensors_statement ||= Service.cassandra.prepare(
    'INSERT INTO sensors (id, turbine_id) ' \
    'VALUES (?, ?)'
  )
end

def seed_sensors_by_status!
  sensors_by_status.each do |data|
    Service.cassandra.execute(sensors_status_statement.bind(data))
  end
end

def sensors_status_statement
  @sensors_status_statement ||= Service.cassandra.prepare(
    'INSERT INTO sensors_by_status (id, turbine_id, status) ' \
    'VALUES (?, ?, ?)'
  )
end

def sensors_by_status
  Sensor.generate_by_status(SENSOR_COUNT)
end

def seed_sensors_by_type!
  sensors_by_type.each do |data|
    Service.cassandra.execute(sensors_type_statement.bind(data))
  end
end

def sensors_by_type
  Sensor.generate_by_type(SENSOR_COUNT)
end

def sensors_type_statement
  @sensors_type_statement ||= Service.cassandra.prepare(
    'INSERT INTO sensors_by_type (id, turbine_id, type) ' \
    'VALUES (?, ?, ?)'
  )
end

def seed_sensor_readings!
  readings_by_sensor.each do |sensor_readings|
    sensor_readings.each do |data|
      Service.cassandra.execute(readings_statement.bind(data))
    end
  end
end

def readings_by_sensor
  Array.new(SENSOR_COUNT) do |sensor_id|
    Reading.generate(sensor_id, READING_COUNT)
  end
end

def readings_statement
  @readings_statement ||= Service.cassandra.prepare(
    'INSERT INTO day_readings_by_sensor (sensor_id, data, day, reading_at) ' \
    'VALUES (?, ?, ?, ?)'
  )
end

def seed_sensor_alerts!
  alerts_by_sensor.each do |sensor_alerts|
    sensor_alerts.each do |data|
      Service.cassandra.execute(alerts_statement.bind(data))
    end
  end
end

def alerts_by_sensor
  Array.new(SENSOR_COUNT) do |sensor_id|
    Alert.generate(sensor_id, ALERT_COUNT)
  end
end

def alerts_statement
  @alerts_statement ||= Service.cassandra.prepare(
    'INSERT INTO month_alerts_by_sensor ' \
    '(sensor_id, level, details, month, alert_at) ' \
    'VALUES (?, ?, ?, ?, ?)'
  )
end
