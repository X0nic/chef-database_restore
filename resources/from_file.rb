actions :load

attribute :database_backup_name, :kind_of => String
attribute :database_name,        :kind_of => String
attribute :extract_to,           :kind_of => String
attribute :source,               :kind_of => String

def initialize(*args)
  super
  @action = :load
end
