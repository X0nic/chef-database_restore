# Cookbook Name:: database_restore
# Recipe:: default
# Author:: Nathan Lee (<nathan@globalphobia.com>)
#
# Copyright (C) 2014 Nathan Lee
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'mysql::server'
include_recipe "database::mysql"
include_recipe "libarchive::default"

s3_database_file node[:database_restore][:database_name] do
  s3_dir_path node[:database_restore][:s3_dir_path]
  s3_bucket node[:database_restore][:s3_bucket]
  database node[:database_restore][:database_name]
  action :create
end

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node[:database_restore][:database_name] do
  connection mysql_connection_info
  action     :create
end

libarchive_file "#{node[:database_restore][:database_name]}.tar" do
  path "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_name]}.tar"
  extract_to Chef::Config[:file_cache_path]
  action :extract
end

libarchive_file "#{node[:database_restore][:database_backup_name]}.sql.gz" do
  path "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_backup_name]}/databases/MySQL/#{node[:database_restore][:database_backup_name]}.sql.gz"
  extract_to "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_backup_name]}.sql"
  action :extract
end

mysql_database 'flush the privileges' do
  connection mysql_connection_info
  sql        'flush privileges'
  action     :query
end

mysql_database "load_#{node[:database_restore][:database_backup_name]}" do
  connection mysql_connection_info
  database_name 'wordpress'
  sql { ::File.open("#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_backup_name]}.sql/data").read }
  action :query
end

mysql_database_user node[:database_restore][:database_user] do
  connection mysql_connection_info
  password   'super_secret'
  action     :create
end

mysql_database_user node[:database_restore][:database_user] do
  connection    mysql_connection_info
  database_name node[:database_restore][:database_name]
  privileges    [:all]
  action        :grant
end
