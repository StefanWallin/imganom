ENV['RACK_ENV'] || ENV['RACK_ENV']='test'

Bundler.require(:default, ENV['RACK_ENV'].to_s.to_sym)
require File.join(File.dirname(__FILE__), '..', 'imganom.rb')

# setup test environment
set :run, false
set :raise_errors, true
set :logging, false

def app
  Imganom
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
