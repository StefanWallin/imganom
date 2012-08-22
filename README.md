Current Status
==============

This project is just started as of 2012-08-22. The only asset currently existing is this project outline. Leave a comment on it if you have any opinions!

The plans is for this software to be used in a Quality Assurance environment being fed screenshots

imganom
=======
Utility to detect anomalies in two images that should be the same, useful for GUI testing.
The utility is two parted:
* a REST-based API for integration in your test suite.
* a web client for approving or disapproving images.

HTTP REST Protocol
==================

PUT or POST /test/imagename
--------------------
Compares the uploaded image on that URL with a previous image uploaded on the same url. Uses <a href="http://pdiff.sourceforge.net/">pdiff / PerceptualDiff</a> for image comparison backend.

<strong>Accepts:</strong>
* <code>file</code> - the new image in image upload multipart binary format.
* <code>project</code> - the project this test is associated with, this should be a integer without whitespace.
* <code>data</code><small><tt>(optional)</tt></small> - stringified JSON that represents what test was run, which commit, who commited and so on. Format is not important, it is recursed and echoed. close to the image. I'm not responsible for whatever you decide to put here.

<strong>Returns:</strong>
* <code>409 Conflict</code> - if the image content is not identical with the old one(according to pdiff). 
* <code>201 Created</code> - if the image does not exist, that is, this is the first image with this name.
* <code>304 Not Modified</code> - if the image content is identical with the previously approved image.
* <code>400 Bad Requeset</code> - no file or project was given, or given in bogus format. Fix your API integration.

Regardless of the response, the server also returns stringified JSON with this structure:
<pre><code>{
	"status": numeric_response_code,
	"url": web_gui_url
}</code></pre>


Web client for approving or disapproving the new images
=======================================================
GET /login/
----------
The system has users, which may have multiple roles, for now these are the roles
* admin
* product owner
* developer

GET /projects/
--------------
Lists the current projects. A user can be owner, developer or admin 

GET /project/id/
----------------
Lists current unapproved images within this project.

GET /backlog/
-------------
Lists currently unapproved images for the current user.

GET /admin/users/
-----------------
Duhh.. if you are admin, you can administer users

GET /admin/projects/
-----------------
Yeah.. if you are admin, you can administer projects and project bindings





