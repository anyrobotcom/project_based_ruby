# Redirect stdout to log files, ugly but working

$out_file = File.new("log/robot.log", "a")

[$stdout, $stderr].each do |io|
  def io.write string
    $out_file.write string
    super
  end
end

# Snippet required for exception catcher

require "sentry-ruby"
require "yaml"

Sentry.init do |config|
  config.dsn = YAML.load_file("config/config.yml")["sentry"]["dsn"]
end

# Load rest rake tasks

require 'standalone_migrations'

StandaloneMigrations::Tasks.load_tasks