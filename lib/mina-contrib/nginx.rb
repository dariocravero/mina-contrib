require 'mina-contrib/helpers'

settings.nginx_upstream ||= lambda { "unix://#{deploy_to}/#{shared_path}/tmp/server.sock" }
settings.nginx_domain_names ||= 'localhost'
settings.nginx_site ||= lambda { application }

namespace :nginx do
  desc 'Reload nginx'
  task :reload do
    queue %{
      echo "-----> Reloading nginx"
      sudo nginx-reload
    }
  end

  desc 'Config nginx for this site' 
  task :config do
    render "#{deploy_to}/current/config/nginx.conf.erb",
           "#{deploy_to}/#{shared_path}/config/nginx.conf"
    invoke :'nginx:link'
  end

  desc 'Create symlink to enable the site in nginx'
  task :link do
    queue %{
      echo "-----> Creating nginx's site symlink"
      #{echo_cmd "sudo nginx-link #{application}"}
    }
  end
  desc 'Removing symlink to disable the site in nginx'
  task :unlink do
    queue %{
      echo "-----> Removing nginx's site symlink"
      #{echo_cmd "sudo nginx-unlink #{application}"}
    }
  end

  desc 'Removes the site from nginx'
  task :destroy do
    invoke :'nginx:unlink'
    invoke :'nginx:reload'
  end
  # desc 'Create symlink to enable the site in nginx'
  # task :link do
  #   queue %{
  #     echo "-----> Creating nginx's site symlink"
  #     #{echo_cmd "ln -sfnv #{deploy_to}/#{shared_path}/config/nginx.conf #{nginx_enabled_sites}/#{nginx_site}"}
  #   }
  # end
  # desc 'Removing symlink to disable the site in nginx'
  # task :unlink do
  #   queue %{
  #     echo "-----> Removing nginx's site symlink"
  #     #{echo_cmd "rm #{nginx_enabled_sites}/#{nginx_site}"}
  #   }
  # end
end
