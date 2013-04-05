require 'mina-contrib/helpers'

settings.environment ||= lambda { rack_env || :production }
settings.monit_service ||= 'service monit'
settings.monit_conf ||= '/etc/monit/conf.d'
settings.monit_process ||= lambda { application }
settings.monit_process_pid_file ||= ''
settings.monit_start_program ||= ''
settings.monit_stop_program ||= ''
settings.monit_host ||= 'localhost'

namespace :monit do
  desc 'Starts monit'
  task :start do
    queue "sudo #{monit_service} start"
  end
  desc 'Stops monit'
  task :stop do
    queue "sudo #{monit_service} stop"
  end
  desc 'Gets monit status'
  task :status do
    queue "sudo monit status"
  end
  desc 'Reload monit'
  task :reload do
    queue "sudo monit reload"
  end

  desc 'Config monit for this instance' 
  task :config do
    queue %{
      echo "-----> Creating monit's config file"
      #{echo_cmd "mkdir -p #{deploy_to}/#{shared_path}/config"}
    }
    render("#{deploy_to}/current/config/monit.conf.erb", "#{deploy_to}/#{shared_path}/config/monit.conf")
    invoke :'monit:link'
  end

  desc "Create monit's config file"
  task :link do
    queue %{
      echo "-----> Linking monit's config file"
      #{echo_cmd "sudo ln -s #{deploy_to}/#{shared_path}/config/monit.conf #{monit_conf}/#{monit_process}"}
    }
  end
  desc "Remove monit's config file"
  task :unlink do
    queue %{
      echo "-----> Unlinking monit's config file"
      #{echo_cmd  "sudo rm #{monit_conf}/#{monit_process}"}
    }
  end

  desc 'Removes the instance from monit'
  task :destroy do
    invoke :'monit:unlink'
    invoke :'monit:reload'
  end
end
