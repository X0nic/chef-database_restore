use_inline_resources

action :load do
  title = new_resource.name

  mysql_connection_info = {
    :host     => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  }

  mysql_database new_resource.database_name do
    connection mysql_connection_info
    action     :create
  end

  libarchive_file new_resource.name do
    extract_to Chef::Config[:file_cache_path]
    action :extract
  end

  libarchive_file "#{node[:database_restore][:database_backup_name]}.sql.gz" do
    path "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_backup_name]}/databases/MySQL/#{node[:database_restore][:database_backup_name]}.sql.gz"
    extract_to "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_backup_name]}.sql"
    action :extract
  end

  mysql_database "load_#{node[:database_restore][:database_backup_name]}" do
    connection mysql_connection_info
    database_name new_resource.database_name
    sql { ::File.open("#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_backup_name]}.sql/data").read }
    action :query
  end

  new_resource.updated_by_last_action(true)
end
