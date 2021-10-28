# frozen_string_literal: true

require 'mongo'

module Service
  module_function

  MONGO_HOST = '127.0.0.1'
  MONGO_PORT = 27017
  MONGO_DB = 'test'

  def mongo
    @mongo ||= Mongo::Client.new(
      ["#{MONGO_HOST}:#{MONGO_PORT}"], database: MONGO_DB
    )
  end
end
