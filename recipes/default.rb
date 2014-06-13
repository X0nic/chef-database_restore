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

require 'fog'

def s3_database_restore_file(s3_bucket, s3_dir_path, database)

  connection = Fog::Storage.new({
    :provider              => 'AWS',
    :aws_access_key_id     => node[:aws][:access_key],
    :aws_secret_access_key => node[:aws][:secret_key]
  })

  Chef::Log.info "Searching for most recent database (#{database}) at s3://#{s3_bucket}/#{s3_dir_path}"

  directory = connection.directories.get(s3_bucket)
  path = directory.files.all(prefix: s3_dir_path).last

  Chef::Log.info "Grabbing retore file from s3://#{s3_bucket}/#{path.key}"

  path.url(::Fog::Time.now + (60*60) )
end

# Install the Fog gem dependencies
#
value_for_platform_family(
  [:ubuntu, :debian]               => %w| build-essential libxslt1-dev libxml2-dev |,
  [:rhel, :centos, :suse, :amazon] => %w| gcc gcc-c++ make libxslt-devel libxml2-devel |
).each do |pkg|
  package(pkg) { action :nothing }.run_action(:upgrade)
end

# Install the Fog gem for Chef run
#
chef_gem("fog") do
  version '1.12.1'
  action :install
end

database_name = 'wordpress'
restore_file = s3_database_restore_file(node[:database_restore][:s3_bucket], node[:database_restore][:s3_dir_path], database_name)

remote_file "#{Chef::Config[:file_cache_path]}/#{database_name}.tar" do
  source restore_file
  notifies :create, "mysql_database[#{database_name}]"
  action :create_if_missing
end


# execute 'load_wordpress_database' do
# end

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database database_name do
  connection mysql_connection_info
  action     :create
end

libarchive_file "#{database_name}.tar" do
  path "#{Chef::Config[:file_cache_path]}/#{database_name}.tar"
  extract_to Chef::Config[:file_cache_path]
  action :extract
end

libarchive_file "wordpressdb.sql.gz" do
  path "#{Chef::Config[:file_cache_path]}/wordpressdb/databases/MySQL/wordpressdb.sql.gz"
  extract_to "#{Chef::Config[:file_cache_path]}/wordpressdb.sql"
  action :extract
end

mysql_database 'flush the privileges' do
  connection mysql_connection_info
  sql        'flush privileges'
  action     :query
end

mysql_database 'load_wordpressdb' do
  connection mysql_connection_info
  database_name 'wordpress'
  sql { ::File.open("#{Chef::Config[:file_cache_path]}/wordpressdb.sql/data").read }
  action :query
end

mysql_database_user 'wordpress' do
  connection mysql_connection_info
  password   'super_secret'
  action     :create
end

mysql_database_user 'wordpress' do
  connection    mysql_connection_info
  database_name database_name
  privileges    [:all]
  action        :grant
end
