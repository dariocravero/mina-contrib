namespace :dep do
  desc 'Setup dep' 
  task :setup do
    queue %{
      echo "-----> Setting up dep"
      #{echo_cmd "gem install dep"}
    }
  end

  desc "Install your app's dependencies" 
  task :install do
    queue %{
      echo "-----> Installing your app's dependencies"
      #{echo_cmd "dep install"}
    }
  end

  desc "Check your app's dependencies status" 
  task :check do
    queue %{
      echo "-----> Checking your app's dependencies"
      #{echo_cmd "dep"}
    }
  end
end
