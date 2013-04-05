settings.config_tasks ||= []

namespace :config do
  desc 'Run configuration tasks' 
  task :all do
    queue %{echo "-----> Configuring the app"} 
    config_tasks.each { |task| invoke task }
  end
end
