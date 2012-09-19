require 'imganom'

use Rack::ShowExceptions
use Rack::CommonLogger
use Rack::Reloader, 0
use Rack::Session::Cookie, :secret => "kjldfskldfs kldfs kljdsf n89yq3ny98ater "

use Warden::Manager do |manager|
	manager.default_strategies :password
	manager.failure_app = Imganom
end

run Imganom
