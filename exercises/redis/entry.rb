# frozen_string_literal: true

require 'redis'

def login
  username = ''

  loop do
    print 'Hello, please enter your username: '
    username = gets.chomp

    break if Service.redis.exists?(username)

    puts "#{username} is not a valid username! Please try again."
  end

  puts "Welcome to Crypto Exchange, #{username}!"

  Service.redis.get(username)
rescue Redis::ConnectionError => e
  puts 'There was an error when loging in! ', e
  nil
end

def register
  username = ''

  loop do
    print 'Hello, please register by entering username ' \
      'you would like to use: '

    username = gets.chomp

    break unless Service.redis.exists?(username)

    puts "#{username} is taken, please choose a different one!"
  end

  id = SecureRandom.uuid
  Service.redis.set(username, id)

  puts 'Account created succesfully!'

  Service.redis.get(username)
rescue StandardError => e
  puts 'There was an error when registering your account! ', e
  nil
end

WELCOME_MESSAGE = <<~EOS
  Hello, welcome to Crypto Exchange!

  Options:

    1 - Login
    2 - Register

EOS

ENTRY_OPTIONS = {
  '1' => method(:login),
  '2' => method(:register)
}.freeze

def enter_exchange
  print WELCOME_MESSAGE
  option = ''

  loop do
    print 'Please choose an option number: '
    option = gets.chomp
    break if %w[1 2].include? option

    puts 'Invalid options, try again!'
  end

  ENTRY_OPTIONS[option].call
end
