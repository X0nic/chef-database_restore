require 'spec_helper'

describe 'database_restore::default' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new
    runner.converge('database_restore::default')
  end
end
