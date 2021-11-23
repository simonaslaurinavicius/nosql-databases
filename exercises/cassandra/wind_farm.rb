#!/usr/bin/env ruby
# frozen_string_literal: true

#   Simple program for a database containing sensor data from wind farm
#   - solution to an exercise designed to gain
#   experience with wide-column stoers.
#
#   Database used - Apache Casssamdra
#
#   Author: Simonas Laurinavicius
#   Course: Non relational databases (NoSQL)
#   Study program, year, group: Informatics, 4, 1
#   Email: simonas.laurinavicius@mif.stud.vu.lt
#   Last updated: 2021-11-23

require_relative 'menu'

loop do
  execute_options
end
