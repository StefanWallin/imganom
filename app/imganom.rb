#!/usr/bin/env ruby
# This actually requires the bundled gems

require "sinatra"
class Imganom < ::Sinatra::Application
   register ::Sinatra::Warden
   set :haml, :format => :html5
   $redis = Redis.new

   
   #Start dummy methods
   def is_valid_api_key(api_key)
      "klsdkl" == api_key.to_s
   end
   
   def projectExists(project)
      123 == project.to_s.to_i
   end

   def imageExists(project, imagename)
      #This method should check if the requested project has an image with that name or not
      123 == project.to_s.to_i && "apa.png" == imagename.to_s
   end
   def validImage(imagedata)
      #This method should check for valid image data
      nil == imagedata

   end
   def imgDiff(project, imagename, imagedata)
      # SecureRandom.random_number(10)
      10
   end
   #End dummy methods

   def testImage(project, imagename, api_key, imagedata)
      if is_valid_api_key(api_key)
         if projectExists(project)
            if !imageExists(project, imagename)
               if validImage(imagedata)
                  # if the image does not exist, that is, this is the first image with this name.
                  [201, "Created"] 
               else
                  #imagedata was borked or image missing
                  [400, "Bad Requestest"] 
               end
            elsif
               #image exists
               diff = imgDiff(project, imagename, imagedata)
               if diff == 0
                  # 0 diff equals the image content is identical with the previously approved image.
                  [200, "Not Modified"]
               else
                  # the image content is not identical with the old one(according to pdiff or md5).
                  out = "Conflict: " + diff.to_s
                  [409, out]
               end
            end
         end
      else
         # Wrong API#key. Get a new one.
         r = '"status": 403, "url":' "http://lolzz" '"description":"<h1>Forbidden</h1><p>Wrong APIkey. Get a new one.</p>"'
         [403, r] 
      end
   end

####                       ####
##                           ##
## Here's the API web server ##
##                           ##
####                       ####

   put '/test/:project/:imagename/:api_key' do |project, imagename, api_key|
      testImage(:project, :imagename, :api_key, nil) #Replace nil with proper imagedata
   end
   post '/test/:project/:imagename/:api_key' do |project, imagename, api_key|
      testImage(:project, :imagename, :api_key, nil) #Replace nil with proper imagedata
   end
   
   #deprecated
   #This method should not persist, for browser debugging only. in future api should only be accessible by curl or the like.
   get '/test/:project/:imagename/:api_key' do |project, imagename, api_key|
      testImage(:project, :imagename, :api_key, nil) #Replace nil with proper imagedata
   end

####                               ####
##                                   ##
## Here's the user facing web server ##
##                                   ##
####                               ####
   post '/unauthenticated/?' do
      redirect "/login/", 303
   end


   get '/login/' do
      haml :login
   end

   post '/auth/' do
     u = env['warden'].authenticate!
     redirect "/"
   end

   get '/logout/' do
     env['warden'].logout
     redirect '/'
   end


   get '/' do
      user = env['warden'].authenticate!
      $redis.set("mykey", "hello world")
      if user
        "Lists currently unapproved images for the current logged in user. <a href='/logout/'>Log out</a> or die!"
      else
        flash.now.alert = env['warden'].message
      end
   end

   get "/myaccount/" do
      u = env['warden'].authenticate!
      "Your Account Details"
   end

   get '/projects/' do
      u = env['warden'].authenticate!
      "Lists the current projects. A user can be owner, developer or admin "
   end

   get '/project/id/' do
      u = env['warden'].authenticate!
      "Lists current unapproved images within this project."
   end

   get '/admin/users/' do
      u = env['warden'].authenticate!
      "Duhh.. if you are admin, you can administer users"
   end

   get '/admin/projects/' do
      u = env['warden'].authenticate!
      "Yeah.. if you are admin, you can administer projects and project bindings"
   end
   
   get '/admin/keys/' do
      u = env['warden'].authenticate!
      "Yeah.. if you are admin with the correct role, you can create or revoke API keys."
   end
end