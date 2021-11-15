# frozen_string_literal: true

require 'cassandra'

class << (Service = Object.new)
  DEFAULT_KEYSPACE = 'system'
  KEYSPACE = 'wind_farm'

  def cassandra
    @cassandra ||= Cassandra.cluster.connect(KEYSPACE)
  rescue StandardError
    puts "Connecting to cluster with #{DEFAULT_KEYSPACE} keyspace"
    Cassandra.cluster.connect(DEFAULT_KEYSPACE)
  end
end
