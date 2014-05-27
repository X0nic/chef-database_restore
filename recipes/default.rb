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

require 'chef/shell_out'

include_recipe 'mysql::server'

# execute 's3cmd ls' do
#   command 's3cmd ls s3://automagic-wordpress/backups/wordpressdb'
#   action :run
# end
ruby_block "Grabbing s3 bucket data" do
  block do
    require 'chef/mixin/shell_out'
    extend Chef::Mixin::ShellOut
    s3_path = ''
    results = shell_out "s3cmd ls #{node[:database_restore][:s3_bucket] | awk '{print $2}'"
    dates = results.stdout.each_line.map do |line|
      d = line.match('(\d{4}(\.\d{2}){5})')[0]
      date = Date.parse(d)
      # Chef::Log.info "Output: #{date}"
      {date: date, path: line.chomp}
    end
    Chef::Log.info "Output: #{dates.sort_by{ |d| d[:date] }.last}"
    newest_s3_path = dates.sort_by{ |d| d[:date] }.last

    Chef::Log.info "s3cmd ls #{newest_s3_path[:path]} | awk '{print $2}'"
    results = shell_out "s3cmd ls #{newest_s3_path[:path]}"
    Chef::Log.info "Output: #{results.stdout}"
  end
end

s3_file "/tmp/wordpress.tar" do
  remote_path "/backups/wordpressdb/2014.05.16.03.11.35/wordpressdb.tar"
  bucket "automagic-wordpress"
  aws_access_key_id node[:aws][:access_key]
  aws_secret_access_key node[:aws][:secret_key]
  # owner "me"
  # group "mygroup"
  # mode "0644"
  action :create
  # decryption_key "my SHA256 digest key"
  # decrypted_file_checksum "SHA256 hex digest of decrypted file"
end
