#!/usr/bin/env ruby

# This is actually our Deploy Script

# ------------------------------ INITIALIZE

require 'yaml'
require 'erb'

# ------------------------------ INSTALL

system "gem install bundler"
system "bundle install"
system "cp config/config.example.yml config/config.yml" # TODO: Dostosuj do potrzeb

# ------------------------------ PRINT SUMMARY

puts "Done!"
