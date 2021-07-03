require "yaml" # YAML support
require "csv" # Load CSV files
require "cgi" # CGI is a large class, providing several categories of methods, many of which are mixed in from other modules
require "securerandom" # Secure generator of various randoms
require "uri" # URI support
require "find" # The Find module supports the top-down traversal of a set of file paths
require "fileutils" # Namespace for several file utility methods for copying, moving, removing, etc
require "pathname" # Pathname represents the name of a file or directory on the filesystem, but not the file itself
require "erb" # Templating
require "rubygems" # Gems
require "bundler/setup" # Bundler
require "json" # JSON parse generate
require "digest" # Used to generate digests
require "httparty" # Used for APIs

Bundler.require(:default)

# Initialize defaults and config

$spinner = TTY::Spinner.new(format: :bouncing_ball)
$spinner.auto_spin
$root_directory = File.expand_path("..", __dir__)
$config = YAML.load_file("#{$root_directory}/config/config.yml")
if $enable_browser
  if $enable_user_agent_spoofing
    options = {
      args: [
        "--user-agent=\"#{$config["chrome"]["user_agent"]}\""
      ],
    }
  else
    options = {}
  end
  begin
    $browser = Watir::Browser.new(:chrome,
                                  headless: $config["chrome"]["headless"],
                                  options: options)
  rescue Selenium::WebDriver::Error::SessionNotCreatedError, Selenium::WebDriver::Error::WebDriverError
    send_alert("Problem with Chromedriver - please login and update!")
  end
  $browser.window.maximize
  Selenium::WebDriver.logger.level = :error
end
$prompt = TTY::Prompt.new
$pastel = Pastel.new
$default_wait = 2.5
$spinner.stop("Initialized!")

# Database

if $enable_database
  db_config = YAML.load_file("#{$root_directory}/config/database.yml")
  ActiveRecord::Base.establish_connection(
    db_config['development']
  )
  Dir.glob("#{$root_directory}/models/*.rb").each do |file|
    require_relative file
  end
end

# Load other stuff here

require_relative "#{$root_directory}/lib/helpers.rb"