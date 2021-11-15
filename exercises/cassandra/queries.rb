# frozen_string_literal: true

require_relative 'service'
require_relative 'sensors/status'
require_relative 'sensors/type'

SENSOR_STATUS_MESSAGE = <<~EOS
  Sensor statuses:

    OK - #{Sensors::Status::OK}
    MAITENANCE_NEEDED - #{Sensors::Status::MAITENANCE_NEEDED}
    OUT_OF_ORDER - #{Sensors::Status::OUT_OF_ORDER}
    STOPPED_MANUALLY - #{Sensors::Status::STOPPED_MANUALLY}

EOS

SENSOR_TYPE_MESSAGE = <<~EOS
  Sensor types:

    WIND_SPEED - #{Sensors::Type::WIND_SPEED}
    TEMPERATURE - #{Sensors::Type::TEMPERATURE}

EOS

def sensors_by_status
  print 'Please enter turbine id: '
  turbine_id = gets.chomp.to_i

  puts SENSOR_STATUS_MESSAGE
  print 'Please enter sensor status: '
  status = gets.chomp.to_i

  options = { turbine_id: turbine_id, status: status }

  execute_query(sensors_by_status_statement, options)
end

def execute_query(statement, options)
  Service.cassandra.execute(statement.bind(options))
end

def sensors_by_status_statement
  @sensors_by_status_statement ||= Service.cassandra.prepare(
    'SELECT * FROM sensors_by_status WHERE turbine_id = ? AND status = ?'
  )
end

def sensors_by_type
  print 'Please enter turbine id: '
  turbine_id = gets.chomp.to_i
  puts SENSOR_TYPE_MESSAGE
  print 'Please enter sensor type: '
  type = gets.chomp.to_i

  options = { turbine_id: turbine_id, type: type }

  execute_query(sensors_by_type_statement, options)
end

def sensors_by_type_statement
  @sensors_by_type_statement ||= Service.cassandra.prepare(
    'SELECT * FROM sensors_by_type WHERE turbine_id = ? AND type = ?'
  )
end

def day_readings
  print 'Please enter sensor id: '
  sensor_id = gets.chomp.to_i

  print 'Please enter the day you want readings for: '
  day = gets.chomp.to_i
  date = Date.new(2021, 1, day)

  options = { sensor_id: sensor_id, day: date }

  execute_query(readings_by_sensor_statement, options)
end

def readings_by_sensor_statement
  @readings_by_sensor_statement ||= Service.cassandra.prepare(
    'SELECT * FROM day_readings_by_sensor WHERE sensor_id = ? AND day = ?'
  )
end

def monthly_alerts
  print 'Please enter sensor id: '
  sensor_id = gets.chomp.to_i

  print 'Please enter the month you want readings for: '
  month = gets.chomp.to_i
  month_date = Date.new(2021, month)

  options = { sensor_id: sensor_id, month: month_date }

  execute_query(alerts_by_sensor_statement, options)
end

def alerts_by_sensor_statement
  @alerts_by_sensor_statement ||= Service.cassandra.prepare(
    'SELECT * FROM month_alerts_by_sensor WHERE sensor_id = ? AND month = ?'
  )
end

def insert_sensor
  print 'Please enter sensor id: '
  sensor_id = gets.chomp.to_i
  print 'Please enter turbine id: '
  turbine_id = gets.chomp.to_i
  puts SENSOR_TYPE_MESSAGE
  print 'Please enter sensor type: '
  type = gets.chomp.to_i

  sensor_options = { id: sensor_id, turbine_id: turbine_id }

  batch = Service.cassandra.batch

  batch.add(insert_sensor_statement.bind(sensor_options))
  batch.add(
    insert_sensor_by_status_statement.bind(
      sensor_options.merge(
        {
          status: Sensors::Status::OK
        }
      )
    )
  )

  batch.add(
    insert_sensor_by_type_statement.bind(
      sensor_options.merge(
        {
          type: type
        }
      )
    )
  )

  Service.cassandra.execute(batch)
end

def insert_sensor_statement
  @insert_sensor_statement ||= Service.cassandra.prepare(
    'INSERT INTO sensors (id, turbine_id) ' \
    'VALUES (?, ?) IF NOT EXISTS'
  )
end

def insert_sensor_by_status_statement
  @insert_sensor_by_status_statement ||= Service.cassandra.prepare(
    'INSERT INTO sensors_by_status (id, turbine_id, status) ' \
    'VALUES (?, ?, ?)'
  )
end

def insert_sensor_by_type_statement
  @insert_sensor_by_type_statement ||= Service.cassandra.prepare(
    'INSERT INTO sensors_by_type (id, turbine_id, type) ' \
    'VALUES (?, ?, ?)'
  )
end
