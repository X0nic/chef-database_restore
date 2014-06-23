# Cookbook Name:: database_restore
# Recipe:: restore
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

database_restore_download_s3_backup_file "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_name]}.tar" do
  aws_access_key_id node[:aws][:access_key]
  aws_secret_access_key node[:aws][:secret_key]
  s3_dir_path node[:database_restore][:s3_dir_path]
  s3_bucket node[:database_restore][:s3_bucket]
  database node[:database_restore][:database_name]
  action :create
end

database_restore_from_file "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_name]}.tar" do
  source "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_name]}.tar"
  database_name node[:database_restore][:database_name]
  database_backup_name node[:database_restore][:database_backup_name]
  extract_to Chef::Config[:file_cache_path]
  mysql_host 'localhost'
  mysql_username 'root'
  mysql_password node[:mysql][:server_root_password]
end
