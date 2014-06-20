use_inline_resources

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

  require 'fog'

  connection = Fog::Storage.new({
    :provider              => 'AWS',
    :aws_access_key_id     => new_resource.aws_access_key_id,
    :aws_secret_access_key => new_resource.aws_secret_access_key
  })

  Chef::Log.info "Searching for most recent database (#{new_resource.database}) at s3://#{new_resource.s3_bucket}/#{new_resource.s3_dir_path}"

  directory = connection.directories.get(new_resource.s3_bucket)
  path = directory.files.all(prefix: new_resource.s3_dir_path).last

  Chef::Log.info "Grabbing retore file from s3://#{new_resource.s3_bucket}/#{path.key}"

  s3_url = path.url(::Fog::Time.now + (60*60) )

  remote_file new_resource.name do
    source s3_url
    action :create_if_missing
  end

  new_resource.updated_by_last_action(true)
end
