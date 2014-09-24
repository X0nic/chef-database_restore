source 'https://rubygems.org'

group :lint do
  gem 'foodcritic', '~> 3.0'
  gem 'rubocop', '~> 0.24.0'
  gem 'rainbow', '< 2.0'
end

group :unit do
  gem 'berkshelf',  '~> 3.0'
  gem 'chefspec',   '~> 3.1'
  gem 'rspec',      '~> 2.14.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.2'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.11'
end

group :kitchen_cloud do
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
  gem 'growl'
  gem 'guard', '~> 2.4'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake'
  gem 'rb-fsevent'
  gem 'ruby_gntp'
  gem 'stove'
  gem 'thor-scmversion'
end
