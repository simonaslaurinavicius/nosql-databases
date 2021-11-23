# frozen_string_literal: true

require_relative 'queries'

EXIT_COMMAND = :exit

FARM_MESSAGE = <<~EOS
  Welcome to your magical wind farm!

  Options:

    1 - View sensors by status
    2 - View sensors by type
    3 - View day readings
    4 - View monthly alerts
    5 - Insert sensor
    6 - Exit

EOS

FARM_OPTIONS = {
  1 => method(:sensors_by_status),
  2 => method(:sensors_by_type),
  3 => method(:day_readings),
  4 => method(:monthly_alerts),
  5 => method(:insert_sensor),
  6 => proc { EXIT_COMMAND }
}.freeze

OPTION_COUNT = (1..6).to_a

def execute_options
  print FARM_MESSAGE
  option = ''

  loop do
    print 'Please choose an option number: '
    option = gets.chomp.to_i
    break if OPTION_COUNT.include? option

    puts 'Invalid options, try again!'
  end

  result = FARM_OPTIONS[option].call
  exit_program if result == EXIT_COMMAND
  print_rows(result)
rescue StandardError => e
  puts "Error executing selected option: #{e}"
end

def exit_program
  puts 'Shutting down..'
  sleep 1
  exit 0
end

def print_rows(result)
  puts "\nResults: "
  result.each_row { |row| puts row }
  puts
end
