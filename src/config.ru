
require 'rubygems'
require 'bundler'

Bundler.require(:app)
require "./imganom.rb"
#own libs
require './lib/warden.rb'
require './lib/user.rb'

use Rack::ShowExceptions
use Rack::CommonLogger
use Rack::Reloader, 0
use Rack::Session::Cookie, :secret => "kjldfskldfs kldfs kljdsf n89yq3ny98ater "

use Warden::Manager do |manager|
	manager.default_strategies :password
	manager.failure_app = Imganom
end

run Imganom
