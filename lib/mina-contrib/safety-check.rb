namespace :deploy do
  desc 'Safety check. Quits if the instance already exists'
  task :safety_check do
    queue %{
      if [ -d #{deploy_to} ]; then
        echo "-----> The instance exists. Quitting!"
        exit 1
      fi
    }
  end
end
