require 'pushover'

task :runner do |t|
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