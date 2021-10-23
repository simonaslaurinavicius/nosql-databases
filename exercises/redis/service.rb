# frozen_string_literal: true

require 'redis'

module Service
  module_function

  REDIS_HOST = 'localhost'
  REDIS_PORT = 6379

  def redis
    @redis ||= Redis.new(host: REDIS_HOST, port: REDIS_PORT)
  end
end
