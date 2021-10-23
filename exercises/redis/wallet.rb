# frozen_string_literal: true

require 'redis'
require 'securerandom'
require 'BigDecimal'

require_relative 'service'

TOKEN_NAME = 'DUNE'
TRANSACTION_TTL = 5

def view_wallet(user_id)
  return create_wallet(user_id) unless Service.redis.exists?("#{user_id}_wallet")

  wallet = Service.redis.hgetall("#{user_id}_wallet")

  puts "You have #{wallet['amount']} of #{wallet['token']}"
  true
rescue Redis::ConnectionError => e
  puts 'There was an error when viewing the wallet! ', e
end

def create_wallet(user_id)
  Service.redis.hset("#{user_id}_wallet", { token: TOKEN_NAME, amount: 0 })

  puts 'Wallet created succesfully!'
  true
rescue StandardError => e
  puts 'There was an error when creating the wallet! ', e
end

def buy_crypto(user_id)
  token_price = BigDecimal(rand(1.5..3), 5)

  tx_id, tx_amount = build_transaction(user_id, token_price)
  total_price = format('%.5f', (tx_amount * token_price))

  Service.redis.watch("#{user_id}_#{tx_id}_fixed_token_price")

  if transaction_confirmed?(tx_amount, total_price)
    execute_transaction(user_id, tx_id, tx_amount, total_price)
  end

  true
rescue Redis::ConnectionError => e
  puts 'There as an error when buying cryptocurreny! ', e
ensure
  Service.redis.unwatch
end

def build_transaction(user_id, token_price)
  puts "Current price for #{TOKEN_NAME}: #{token_price}"
  print 'Please choose an amount to buy: '
  amount = gets.chomp.to_i
  tx_id = SecureRandom.uuid
  Service.redis.setex("#{user_id}_#{tx_id}_fixed_token_price",
                      TRANSACTION_TTL,
                      token_price)
  [tx_id, amount]
end

def execute_transaction(user_id, tx_id, tx_amount, total_price)
  old_amount = Service.redis.hget("#{user_id}_wallet", 'amount')
  new_amount = Integer(old_amount) + tx_amount

  result = Service.redis.multi do |transaction|
    transaction.hset("tx_#{tx_id}", { token: TOKEN_NAME, amount: tx_amount })
    transaction.hset("#{user_id}_wallet", 'amount', new_amount)
  end

  if result
    puts "You've bought #{tx_amount} of #{TOKEN_NAME} for #{total_price}"
  else
    puts 'Transaction unsuccesful, token price expired! Please try again.'
  end
end

def transaction_confirmed?(amount, total_price)
  puts "You are buying #{amount} of #{TOKEN_NAME} for #{total_price}."
  puts "This price is valid for #{TRANSACTION_TTL} seconds."
  print 'Do you want to buy? (y/n):  '
  gets.chomp == 'y'
end

WALLET_MESSAGE = <<~EOS
  Options:

    1 - Buy crypto
    2 - View wallet
    3 - Exit

EOS

WALLET_OPTIONS = {
  '1' => method(:buy_crypto),
  '2' => method(:view_wallet),
  '3' => proc { false }
}.freeze

def execute_wallet_options(id)
  print WALLET_MESSAGE
  option = ''

  loop do
    print 'Please choose an option number: '
    option = gets.chomp
    break if %w[1 2 3].include? option

    puts 'Invalid options, try again!'
  end

  WALLET_OPTIONS[option].call(id)
end
