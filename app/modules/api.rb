#!/usr/bin/env ruby

####                       ####
##                           ##
## Here's the API web server ##
##                           ##
####                       ####

#own libs
require_relative 'warden.rb'
require_relative 'user.rb'

module Imganom
  class API < Sinatra::Application
    set :haml, :format => :html5
    $redis = Redis.new

    def testImage (project, imagename, api_key, imagedata)
      [200, { "Content-Type" => "text/plain" }, request.env]
    end

    put '/:project/:imagename/:api_key' do |project, imagename, api_key|
      testImage(:project, :imagename, :api_key, nil) #Replace nil with proper imagedata
    end

    post '/:project/:imagename/:api_key' do |project, imagename, api_key|
      testImage(:project, :imagename, :api_key, nil) #Replace nil with proper imagedata
    end

    # deprecated
    # This method should not persist, for browser debugging only. in future api
    # should only be accessible by curl or the like.
    get '/:project/:imagename/:api_key' do |project, imagename, api_key|
      testImage(:project, :imagename, :api_key, nil) #Replace nil with proper imagedata
    end

    def self.new(*)
      super
    end
  end #class
end #module