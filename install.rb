#!/usr/bin/env ruby

# This is actually our Deploy Script

# ------------------------------ INITIALIZE

require 'yaml'
require 'erb'

# ------------------------------ INSTALL

# puts "Going to install bundler..."
# system "gem install bundler"
# puts "Going to install gems..."
# system "bundle install"
# system "cp config/config.example.yml config/config.yml" # TODO: Dostosuj do potrzeb

puts `which ruby`
puts `which bundle`

# ------------------------------ PRINT SUMMARY

puts "Done!"
