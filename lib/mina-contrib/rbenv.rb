namespace :rbenv do
  task :rehash do
    queue %{
      echo "-----> Rehashing rbenv"
      #{echo_cmd %{export PATH="#{rbenv_path}/bin:$PATH"}}

      if ! which rbenv >/dev/null; then
        echo "! rbenv not found"
        echo "! If rbenv is installed, check your :rbenv_path setting."
        exit 1
      fi

      #{echo_cmd %{rbenv rehash}}
    }
  end
end
