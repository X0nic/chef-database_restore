actions :create

attribute :aws_access_key_id,     :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :s3_bucket,             :kind_of => String
attribute :s3_dir_path,           :kind_of => String
attribute :database,              :kind_of => String

def initialize(*args)
  super
  @action = :create
end
