#!/usr/bin/env ruby
# frozen_string_literal: true

#   Entry point for toy crypto exchange program - solution to an
#   exercise designed to gain experience with key-value databases.
#
#   Database used - Redis
#
#   Author: Simonas Laurinavicius
#   Course: Non relational databases (NoSQL)
#   Study program, year, group: Informatics, 4, 1
#   Email: simonas.laurinavicius@mif.stud.vu.lt
#   Last updated: 2021-10-28

require_relative 'entry'
require_relative 'wallet'

def exit_exchange
  puts 'Shutting down..'
  sleep 1
  exit 0
end

id = enter_exchange
exit_exchange unless id

while execute_wallet_options(id)

end

exit_exchange
