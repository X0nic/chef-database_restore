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
ruby_block "Running windows finishing script" do
  block do
    require 'chef/mixin/shell_out'
    extend Chef::Mixin::ShellOut
    Chef::Log.info "This will take a while to complete. Sit back and have some
beer."
    results = shell_out "s3cmd ls s3://automagic-wordpress/backups/wordpressdb/"
    Chef::Log.info "Output: #{ results.stdout }"
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
