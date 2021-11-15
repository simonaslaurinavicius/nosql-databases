# frozen_string_literal: true

require_relative 'service'

def create_db!
  create_keyspace!
  create_tables!
end

def create_keyspace!
  Service.cassandra.execute('DROP KEYSPACE IF EXISTS wind_farm')
  Service.cassandra.execute(
    'CREATE KEYSPACE wind_farm ' \
    "WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1}"
  )
  Service.cassandra.execute('USE wind_farm')
end

def create_tables!
  create_sensors!
  create_sensors_by_status!
  create_sensors_by_type!
  create_day_readings_by_sensor!
  create_month_alerts_by_sensor!
end

def create_sensors!
  Service.cassandra.execute(
    'CREATE TABLE sensors( ' \
    'id INT, ' \
    'turbine_id INT, ' \
    'PRIMARY KEY ((turbine_id, id)))'
  )
end

def create_sensors_by_status!
  Service.cassandra.execute(
    'CREATE TABLE sensors_by_status( ' \
    'id INT, ' \
    'turbine_id INT, ' \
    'status TINYINT, ' \
    'PRIMARY KEY (turbine_id, status, id))' \
  )
end

def create_sensors_by_type!
  Service.cassandra.execute(
    'CREATE TABLE sensors_by_type( ' \
    'id INT, ' \
    'turbine_id INT, ' \
    'type TINYINT, ' \
    'PRIMARY KEY (turbine_id, type, id))' \
  )
end

def create_day_readings_by_sensor!
  Service.cassandra.execute(
    'CREATE TABLE day_readings_by_sensor( ' \
    'sensor_id INT, ' \
    'data FLOAT, ' \
    'day DATE, ' \
    'reading_at TIMESTAMP, ' \
    'PRIMARY KEY((sensor_id, day), reading_at)) ' \
    'WITH CLUSTERING ORDER BY (reading_at DESC)' \
  )
end

def create_month_alerts_by_sensor!
  Service.cassandra.execute(
    'CREATE TABLE month_alerts_by_sensor( ' \
    'sensor_id INT, ' \
    'level TINYINT, ' \
    'details TEXT, ' \
    'month DATE, ' \
    'alert_at TIMESTAMP, ' \
    'PRIMARY KEY((sensor_id, month), alert_at)) ' \
    'WITH CLUSTERING ORDER BY (alert_at DESC)' \
  )
end
