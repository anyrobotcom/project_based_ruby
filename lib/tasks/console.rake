task :console do |t|
  $enable_browser = true
  $enable_database = true
  require_relative "../../lib/boot"
  binding.pry
end