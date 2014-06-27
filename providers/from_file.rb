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

use_inline_resources

action :load do
  mysql_connection_info = {
    host:     new_resource.mysql_host,
    username: new_resource.mysql_username,
    password: new_resource.mysql_password
  }

  mysql_database new_resource.database_name do
    connection mysql_connection_info
    action     :create
  end

  libarchive_file new_resource.name do
    extract_to new_resource.extract_to
    action :extract
  end

  libarchive_file "#{new_resource.database_backup_name}.sql.gz" do
    path "#{new_resource.extract_to}/#{new_resource.database_backup_name}/databases/MySQL/#{new_resource.database_backup_name}.sql.gz"
    extract_to "#{new_resource.extract_to}/#{new_resource.database_backup_name}.sql"
    action :extract
  end

  mysql_database "load_#{new_resource.database_backup_name}" do
    connection mysql_connection_info
    database_name new_resource.database_name
    sql { ::File.open("#{new_resource.extract_to}/#{new_resource.database_backup_name}.sql/data").read }
    action :query
  end

  new_resource.updated_by_last_action(true)
end
