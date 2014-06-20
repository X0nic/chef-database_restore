actions :load

attribute :database_name, :kind_of => String
attribute :source,        :kind_of => String

def initialize(*args)
  super
  @action = :load
end
