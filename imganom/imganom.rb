#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'securerandom'



class Imganom < Sinatra::Application

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
      SecureRandom.random_number(10)
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

   # Here's the API web server

   put '/test/:project/:imagename/:api_key' do 
      testImage(params[:project], params[:imagename], params[:api_key], nil) #Replace nil with proper imagedata
   end
   post '/test/:project/:imagename/:api_key' do
      testImage(params[:project], params[:imagename], params[:api_key], nil) #Replace nil with proper imagedata
   end
   
   #deprecated
   #This method should not persist, for browser debugging only. in future api should only be accessible by curl or the like.
   get '/test/:project/:imagename/:api_key' do
      testImage(params[:project], params[:imagename], params[:api_key], nil) #Replace nil with proper imagedata
   end



   # Here's the user facing web server

   enable :sessions

   set(:auth) do |*roles|   # <- notice the splat here
      condition do
         unless logged_in? && roles.any? {|role| current_user.in_role? role }
            redirect "/login/", 303
         end
      end
   end

   get "/my/account/", :auth => [:user, :admin] do
      "Your Account Details"
   end

   get "/only/admin/", :auth => :admin do
      "Only admins are allowed here!"
   end


   get '/', :auth => [:user, :admin] do
      "Lists currently unapproved images for the current logged in user."
   end

   get '/login/' do
      "The system has users, which may have multiple roles, for now these are the roles
      <ul><li>admin</li>
      <li>product owner</li>
      <li>developer</li>
      </ul>"
   end

   get '/projects/', :auth => [:user, :admin] do
      "Lists the current projects. A user can be owner, developer or admin "
   end

   get '/project/id/', :auth => [:user, :admin] do
      "Lists current unapproved images within this project."
   end

   get '/admin/users/', :auth => :admin do
      "Duhh.. if you are admin, you can administer users"
   end

   get '/admin/projects/', :auth => :admin do
      "Yeah.. if you are admin, you can administer projects and project bindings"
   end
   
   get '/admin/keys/', :auth => :admin do
      "Yeah.. if you are admin with the correct role, you can create or revoke API keys."
   end
end