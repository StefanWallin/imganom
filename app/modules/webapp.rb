#!/usr/bin/env ruby

####                               ####
##                                   ##
## Here's the user facing web server ##
##                                   ##
####                               ####

#own libs
require_relative 'warden.rb'
require_relative 'user.rb'

module Imganom
  class Webapp < Sinatra::Application
    register Sinatra::Warden
    set :haml, :format => :html5
    
    #set root folder to parent folder since application file is within modules
    set :root, File.join(File.dirname(__FILE__), "..")
    
    #set :public_folder, 'public' #this is default
    $redis = Redis.new

    post '/unauthenticated/?' do
      redirect "/login/", 303
    end


    get '/login/' do
      haml :login
    end

    post '/auth/' do
      u = ENV['warden'].authenticate!
      redirect "/"
    end

    get '/logout/' do
      ENV['warden'].logout
      redirect '/'
    end


    get '/' do
      user = env['warden'].authenticate!
      $redis.set("mykey", "hello world")
      if user
        "Lists currently unapproved images for the current logged in user. <a href='/logout/'>Log out</a> or die!"
      else
        flash.now.alert = ENV['warden'].message
      end
    end

    get "/myaccount/" do
      u = ENV['warden'].authenticate!
      "Your Account Details"
    end

    get '/projects/' do
      u = ENV['warden'].authenticate!
      "Lists the current projects. A user can be owner, developer or admin "
    end

    get '/project/id/' do
      u = ENV['warden'].authenticate!
      "Lists current unapproved images within this project."
    end

    get '/admin/users/' do
      u = ENV['warden'].authenticate!
      "Duhh.. if you are admin, you can administer users"
    end

    get '/admin/projects/' do
      u = ENV['warden'].authenticate!
      "Yeah.. if you are admin, you can administer projects and project bindings"
    end

    get '/admin/keys/' do
      u = ENV['warden'].authenticate!
      "Yeah.. if you are admin with the correct role, you can create or revoke API keys."
    end
    
    def self.new(*)
      super
    end
  end #class
end #module