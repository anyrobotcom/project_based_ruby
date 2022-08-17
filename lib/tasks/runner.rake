require 'pushover'

task :runner do |t|
  # --- START OF DEBUG ---
  puts "---------- SCRIPT DETAILS"
  puts "RUNNING FILE: #{__dir__ + "/" + __FILE__}"
  if File.exist?("input/payload.json")
    puts "---------- PAYLOAD"
    puts `cat input/payload.json`
  else
    puts "PAYLOAD: NONE"
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
  # Check local environment
  environment = begin
    File.read(".anyrobot-environment")
  rescue Errno::ENOENT
    "production"
  end
  # Die if no ask
  abort "[AnyRobot] No TASK supploed, use like: bundle exec rake runner TASK=namespace/task_name" if ENV["TASK"].nil?
  # Load info
  puts "[AnyRobot] Starting task: #{ENV["TASK"]} @ #{Time.now}"
  file_name = "#{File.expand_path("../..", __dir__)}/tasks/#{ENV["TASK"]}.rb"
  # Check and run
  if File.file?(file_name)
    # Load timeouts data
    config = YAML.load_file("#{File.expand_path("../..", __dir__)}/config/config.yml")
    timeout_in_seconds = nil # Disable by default
    # Set timeout block
    if config["timeout"]["enable"] == true
      # Set default based on config
      timeout_in_seconds = config["timeout"]["default"]
      puts "[AnyRobot] Timeout enabled and set to default value #{timeout_in_seconds} seconds..."
      puts "[AnyRobot] TEST Message"
    else
      puts "[AnyRobot] Timeout disabled!"
    end
    # Run task
    begin
      # Wykonaj zadanie w ograniczeniu czasowym
      Timeout::timeout(timeout_in_seconds) {
        require_relative file_name
      }
      # Pushover do Prezesa
      Pushover::Message.new(
        token: config["pushover"]["api_token"],
        user: config["pushover"]["user_key"],
        message: "[AnyRobot] Done: #{ENV["TASK"]}",
      ).push
    rescue => exception
      if environment == "development"
        binding.pry # If that's development, let's debug with pry...
      else
        # Screenshot
        screenshot = "cache/problem_#{Time.now.to_s.gsub(/\s/, '_')}.png"
        `screencapture #{screenshot}`
        puts "Screenshot saved: #{screenshot}"
        # Pushover do Prezesa
        Pushover::Message.new(
          token: config["pushover"]["api_token"],
          user: config["pushover"]["user_key"],
          message: "[AnyRobot] Exception: #{exception} in #{ENV["TASK"]} - take a look!",
        ).push
        # Zaloguj do Sentry
        Sentry.capture_exception(
          exception,
          tags: {
            'task': ENV["TASK"]
          },
          environment: environment,
          release: `git rev-parse HEAD`.strip
        )
        raise exception # Always re-raise
      end
    end
  else
    abort "[AnyRobot] Task not exist!"
  end
end
