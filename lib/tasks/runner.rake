task :runner do |t|
  # Die if no ask
  abort "[AnyRobot] No TASK supplied, use like: bundle exec rake runner TASK=namespace/task_name" if ENV["TASK"].nil?
  # Load info
  puts "[AnyRobot] Starting task: #{ENV["TASK"]} @ #{Time.now}"
  file_name = "#{File.expand_path("../..", __dir__)}/tasks/#{ENV["TASK"]}.rb"
  # Check and run
  if File.file?(file_name)
    require_relative file_name
  else
    abort "[AnyRobot] Task not exist!"
  end
end