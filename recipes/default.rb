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
