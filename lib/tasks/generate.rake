namespace :generate  do
  desc "Generate valid task"
  task :task => :environment do
    if ENV["NAME"].blank?
      puts "You have to specify valid parameter NAME=namespace/task_name"
    else
      if /^([a-z]*)\/([_a-z]*)$/.match?(ENV["NAME"])
        path_name = "tasks/" + ENV["NAME"].split("/")[0]
        full_name = "tasks/" + ENV["NAME"] + ".rb"
        abort("File #{full_name} exist!") if File.exists?(full_name)
        FileUtils.mkdir_p(path_name) unless File.exists?(path_name)
        File.open(full_name, 'w') do |f|
          f.write ERB.new(
            File.read(
              "templates/task.erb.rb"
            )
          ).result(binding)
          puts "Generated: #{full_name}"
        end
      else
        puts "Invalid NAME, it should be like NAME=namespace/task_name"
      end
    end
  end

  desc "Generate valid model"
  task :model => :environment do
    if ENV["NAME"].blank?
      puts "You have to specify valid parameter NAME=model_name"
    else
      if /^([_a-z]*)$/.match?(ENV["NAME"])
        full_name = "models/" + ENV["NAME"] + ".rb"
        abort("File #{full_name} exist!") if File.exists?(full_name)
        File.open(full_name, 'w') do |f|
          f.write ERB.new(
            File.read(
              "templates/model.erb.rb"
            )
          ).result(binding)
          puts "Generated: #{full_name}"
          Rake::Task["db:new_migration"].invoke("create_#{ENV["NAME"].pluralize}")
        end
      else
        puts "Invalid NAME, it should be like NAME=model_name"
      end
    end
  end
end