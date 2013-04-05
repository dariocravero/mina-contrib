require 'mina-contrib/helpers'
include Mina::Contrib::Helpers

settings.nginx_enabled_sites ||= '/etc/nginx/conf.d'
settings.nginx_upstream ||= lambda { "unix://#{deploy_to}/#{shared_path}/tmp/server.sock" }
settings.nginx_domain_names ||= 'localhost'
settings.nginx_site ||= lambda { application } 

namespace :nginx do
  desc 'Starts nginx'
  task :start do
    queue %{
      echo "-----> Starting nginx"
      sudo service nginx start 
    }
  end
  desc 'Stops nginx'
  task :stop do
    queue %{
      echo "-----> Stopping nginx"
      sudo service nginx stop 
    }
  end
  desc 'Gets nginx reload for the app'
  task :reload do
    queue %{
      echo "-----> Reloading nginx"
      sudo service nginx reload
    }
  end
  desc 'Gets nginx status for the app'
  task :status do
    queue 'sudo service nginx status'
  end

  desc 'Config nginx for this site' 
  task :config do
    queue %{
      echo "-----> Creating nginx's config file"
      #{echo_cmd "mkdir -p #{deploy_to}/#{shared_path}/config"}
    }
    render("#{deploy_to}/current/nginx.conf.erb", "#{deploy_to}/#{shared_path}/config/nginx.conf")
    invoke :'nginx:link'
  end

  desc 'Create symlink to enable the site in nginx'
  task :link do
    queue %{
      echo "-----> Creating nginx's site symlink"
      #{echo_cmd "sudo ln -sfnv #{deploy_to}/#{shared_path}/config/nginx.conf #{nginx_enabled_sites}/#{nginx_site}"}
    }
  end
  desc 'Removing symlink to disable the site in nginx'
  task :unlink do
    queue %{
      echo "-----> Removing nginx's site symlink"
      #{echo_cmd "sudo rm #{nginx_enabled_sites}/#{nginx_site}"}
    }
  end

  desc 'Removes the site from nginx'
  task :destroy do
    invoke :'nginx:unlink'
    invoke :'nginx:reload'
  end
end
