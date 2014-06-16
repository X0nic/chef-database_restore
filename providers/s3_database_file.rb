require 'fog'

# use_inline_resources

action :create do
  title = new_resource.name

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

  remote_file "#{Chef::Config[:file_cache_path]}/#{node[:database_restore][:database_name]}.tar" do
    source restore_file
    action :create_if_missing
  end

  new_resource.updated_by_last_action(true)
end
