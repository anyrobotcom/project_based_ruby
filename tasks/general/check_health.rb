#!/usr/bin/env ruby -W0

# frozen_string_literal: true

require "bundler"

Bundler.require(:default)

# TODO: Passing ANYROBOT_JOB and ANYROBOT_TASK to the script...

# --- START OF DEBUG ---
puts "---------- SCRIPT DETAILS"
puts "RUNNING FILE: #{__FILE__}"
payload_file = "#{__dir__}/../../jobs/#{ENV["ANYROBOT_JOB"]}.json"
puts "---------- PAYLOAD"
if File.exist?(payload_file)
  puts IO.read(payload_file)
else
  puts "<PAYLOAD FILE NOT PRESENT>"
end
puts "---------- RUBY DETAILS"
puts "RUBY: " + `which ruby`
puts "GEM: " + `which gem`
puts "BUNDLE: " + `which bundle`
puts "RAKE: " + `which rake`
puts "VERSION: " + `ruby --version`
puts "RUNNING FILE: #{__FILE__}"
puts "---------- RBENV BASICS"
puts "Global: " + `rbenv global` 
puts "Local: " + `rbenv local`
puts "From .ruby-version file: " + `cat .ruby-version`
puts "---------- RBENV DOCTOR OUTPUT"
puts `curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash`
puts "---------- CHROMEDRIVER"
puts "Chromedriver path: " + `which chromedriver`
puts "Chromedriver version: " + `chromedriver --version`
puts "---------- ENV DETAILS"
ENV.each do |env|
  puts "#{env[0]}: #{env[1]}"
end
puts "---------- ARGV DETAILS"
ARGV.each do |env|
  puts env.inspect
end
# --- END OF DEBUG ---
puts "---------- SCRIPT BELOW"
spinner = TTY::Spinner.new(format: :bouncing_ball)
browser = Watir::Browser.new(:chrome)
spinner.stop("Initialized!")
browser.goto "https://www.whatismyip.com/user-agent-info/"
puts "Your full setup details (your 'user agent string'): #{browser.h5({ class: 'card-title' }).text}"
browser.close