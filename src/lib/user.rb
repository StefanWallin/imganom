class User
  attr_accessor :email

  def initialize(useremail)
    @email = useremail
  end

  def authenticate(password)
    if @email == "a@a.com" && password == "test"
      return true
    else
      return nil
    end
  end
end