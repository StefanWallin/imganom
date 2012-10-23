require_relative 'user.rb'

::Warden::Manager.serialize_into_session do |user| 
  user.email
end
::Warden::Manager.serialize_from_session do |email| 
  User.new(email)
end
 
::Warden::Manager.before_failure do |env,opts|
  # Sinatra is very sensitive to the request method
  # since authentication could fail on any type of method, we need
  # to set it for the failure app so it is routed to the correct block
  ENV['REQUEST_METHOD'] = "POST"
end
 
::Warden::Strategies.add(:password) do
  def valid?
    params["email"] && params["password"]
  end
 
  def authenticate!
    u = User.new(params["email"])
    if u.authenticate(params["password"]).nil?
      print "fail\n"
      fail!("Could not log in")
    else
      print "success\n"
      success!(u)
    end
  end
end
