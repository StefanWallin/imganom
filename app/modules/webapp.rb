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
    set :haml, :format => :html5

    #set root folder to parent folder since application file is within modules
    set :root, File.join(File.dirname(__FILE__), "..")

    #this is default
    #set :public_folder, 'public' 

    def warden
      #warden shorthand helper method
      request.env['warden']
    end

    post '/unauthenticated/?' do
      redirect "/login/", 303
    end

    get '/login' do
      print "\nprocessing /login/"
      haml :login
    end

    get '/logout/' do
      warden.logout
      redirect '/'
    end

    get '/' do
      print "\nprocessing /"
      u = warden.authenticate!
      "Lists currently unapproved images for the current logged in user. <a href='/logout/'>Log out</a> or die!"
    end

    get "/myaccount/" do
      u = warden.authenticate!
      "Your Account Details"
    end

    get '/projects/' do
      print "\nprocessing /projects/"
      u = warden.authenticate!
      "Lists the current projects. A user can be owner, developer or admin "
    end

    get '/project/id/' do
      u = warden.authenticate!
      "Lists current unapproved images within this project."
    end

    get '/admin/users/' do
      u = warden.authenticate!
      "Duhh.. if you are admin, you can administer users"
    end

    get '/admin/projects/' do
      u = warden.authenticate!
      "Yeah.. if you are admin, you can administer projects and project bindings"
    end

    get '/admin/keys/' do
      u = warden.authenticate!
      "Yeah.. if you are admin with the correct role, you can create or revoke API keys."
    end
    
    def self.new(*)
      super
    end
  end #class
end #module