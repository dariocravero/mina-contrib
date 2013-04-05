settings.cron_jobs ||= []

namespace :cron do
  desc 'Install cron jobs' 
  task :install do
    if cron_jobs.count > 0
      invoke :'cron:uninstall'
      queue %{echo "-----> Creating cron jobs"}
      cronjobs_tmp_file = "#{deploy_to}/tmp/cronjobs.tmp"
      render("#{templates_path}/cronjobs.tmp.erb", cronjobs_tmp_file) 
      queue %{
        #{echo_cmd "cat <(crontab -l) <(cat #{cronjobs_tmp_file}) | crontab -"}
        #{echo_cmd "rm #{cronjobs_tmp_file}"}
      }
    end
  end

  desc 'Uninstall cron jobs'
  task :uninstall do
    queue %{
      echo "-----> Uninstalling existing cron jobs"
      #{echo_cmd "cat <(crontab -l | sed '/#_CRONJOBS_START_/,/#_CRONJOBS_END_/d') | crontab -"}
    }
  end
end
