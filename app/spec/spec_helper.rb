ENV['RACK_ENV'] || ENV['RACK_ENV']='test'
require_relative File.join(File.dirname(__FILE__), '..', 'config', 'boot.rb')

def app
  Rack::Builder.new do
    eval File.read(File.join(File.dirname(__FILE__), '..', 'config.ru'))
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
