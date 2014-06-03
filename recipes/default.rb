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
