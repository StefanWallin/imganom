require 'spec_helper'

describe "Login specification states that it" do

  it "should respond to GET" do
    get '/'
    last_response.status.should == 401
    last_response.body.should match(/Login!/)
  end

end