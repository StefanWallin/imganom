require File.dirname(__FILE__) + '/config/boot.rb'

use ::Rack::ShowExceptions
# use Rack::CommonLogger
# use Rack::Reloader, 0
use ::Rack::Session::Cookie, :secret => "kjldfskldfs kldfs kljdsf n89yq3ny98ater "

use ::Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Imganom::Webapp
end

run Rack::URLMap.new({
  "/"    => Imganom::Webapp,
  "/api" => Imganom::API
})



