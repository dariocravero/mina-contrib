require 'mina-contrib/helpers'

settings.environment ||= lambda { padrino_env || rails_env || :production }
settings.puma_service ||= 'puma'
settings.puma_conf ||= '/etc/puma.conf'
settings.puma_socket ||= lambda { "unix://#{deploy_to}/#{shared_path}/tmp/puma/socket" }
settings.puma_pid ||= lambda { "#{deploy_to}/#{shared_path}/tmp/puma/pid" }
settings.puma_state ||= lambda { "#{deploy_to}/#{shared_path}/tmp/puma/state" }
settings.puma_activate_control_app ||= true
settings.puma_min_threads ||= 1
settings.puma_max_threads ||= 5
settings.puma_on_restart ||= false

namespace :puma do
  desc 'Starts puma'
  task :start do
    queue "sudo puma-start #{application}"
  end
  desc 'Stops puma'
  task :stop do
    queue "sudo puma-stop #{application}"
  end
  # TODO Implement in upstart script
  # desc 'Gets puma status'
  # task :status do
  #   queue "sudo status #{puma_service} app=#{deploy_to}/current"
  # end
  desc 'Restart puma'
  task :restart do
    queue "sudo puma-restart #{application}"
  end

  # desc 'Config puma for this instance' 
  # task :config do
  #   queue %{
  #     echo "-----> Creating puma's config file"
  #     #{echo_cmd "mkdir -p #{deploy_to}/#{shared_path}/config"}
  #     #{echo_cmd "mkdir -p #{deploy_to}/#{shared_path}/tmp/puma"}
  #   }
  #   render("#{deploy_to}/current/config/puma.rb.erb", "#{deploy_to}/#{shared_path}/config/puma.rb")
  #   invoke :'puma:link'
  # end
  desc 'Config puma for this instance' 
  task :config do
    queue %{echo "-----> Creating puma's config file"}
    render("#{deploy_to}/current/config/puma.rb.erb",
           "#{deploy_to}/#{shared_path}/config/puma.rb")
    invoke :'puma:link'
  end

  desc "Create reference in the jungle"
  task :link do
    queue %{
      echo "-----> Creating reference in the jungle"
      #{echo_cmd "sudo puma-link #{application}"}
    }
  end
  desc "Remove reference in the jungle"
  task :unlink do
    queue %{
      echo "-----> Removing reference in the jungle"
      #{echo_cmd "sudo puma-unlink #{application}"}
    }
  end

  # desc "Create reference in pumas' config manager"
  # task :link do
  #   queue %{
  #     echo "-----> Creating reference in pumas' config manager"
  #     if [ `grep "#{deploy_to}/current" #{puma_conf} | wc -l` -eq 0 ]; then
  #       #{echo_cmd "echo '#{deploy_to}/current' | tee -a #{puma_conf}"}
  #     fi;
  #   }
  # end
  # desc "Remove reference in pumas' config manager"
  # task :unlink do
  #   queue %{
  #     echo "-----> Removing reference in pumas' config manager"
  #     #{echo_cmd  "sed -i -e \"/#{deploy_to}\/current/d\" #{puma_conf}"}
  #   }
  # end

  desc 'Removes the instance from puma'
  task :destroy do
    invoke :'puma:stop'
    invoke :'puma:unlink'
  end
end
