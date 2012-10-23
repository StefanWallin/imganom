ENV["RACK_ENV"] ||= "development"

require 'bundler'
Bundler.setup

Bundler.require(:default, ENV['RACK_ENV'].to_s.to_sym)

Dir["./modules/**/*.rb"].each { |f| require f }

