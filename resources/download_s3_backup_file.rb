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

actions :create

attribute :aws_access_key_id,     kind_of: String
attribute :aws_secret_access_key, kind_of: String
attribute :s3_bucket,             kind_of: String
attribute :s3_dir_path,           kind_of: String
attribute :database,              kind_of: String

def initialize(*args)
  super
  @action = :create
end
