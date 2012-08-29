Current Status
==============

This project is just started as of 2012-08-22. The only asset currently existing is this project outline. Leave a comment on it if you have any opinions!

The plans is for this software to be used in a Quality Assurance environment being fed screenshots

imganom
=======
Utility to detect anomalies in two images that should be the same, useful for GUI testing.
The utility is two parted:
* a <a href="#http-rest-protocol">REST-based API</a> for integration in your test suite.
* a <a href="#web-client-for-approving-or-disapproving-the-new-images">web client</a> for approving or disapproving images.

HTTP REST Protocol
==================

PUT or POST /test/:projectid/:imagename/:api_key
--------------------
Compares the uploaded image on that URL with a previous image uploaded on the same url. Uses <a href="http://pdiff.sourceforge.net/">pdiff / PerceptualDiff</a> for image comparison backend.

<strong>Accepts:</strong>
* <code>file</code> - the new image in image upload multipart binary format.
* <code>project</code> - the project this test is associated with, this should be a integer without whitespace.
* <code>data</code><small><tt>(optional)</tt></small> - stringified JSON that represents what test was run, which commit, who commited and so on. Format is not important, it is recursed and echoed. close to the image. I'm not responsible for whatever you decide to put here.

<strong>Returns:</strong>
* <code>200 Not Modified</code> - if the image content is identical with the previously approved image.
* <code>201 Created</code> - if the image does not exist, that is, this is the first image with this name.
* <code>400 Bad Request</code> - no file or project was given, or given in bogus format. Fix your API integration.
* <code>403 Forbidden</code> - Wrong API-key. Get a new one.
* <code>409 Conflict</code> - if the image content is not identical with the old one(according to pdiff). 

Regardless of the response, the server also returns stringified JSON with this structure:
<pre><code>{
	"status": numeric_response_code,
	"description": description of error/ok,
	"url": web_gui_url
}</code></pre>


Web client for approving or disapproving the new images
=======================================================
GET /
-------------
Lists currently unapproved images for the current logged in user.


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


GET /admin/users/
-----------------
Duhh.. if you are admin, you can administer users

GET /admin/projects/
-----------------
Yeah.. if you are admin, you can administer projects and project bindings


Data types
==========

image
-----
* <code>string</code> <code>path</code> - relative path from standard directory, <strong>part of primary key</strong>
* <code>enum</code> <code>state</code> - <code>approved</code>/<code>pending</code>, <strong>part of primary key</strong> 
* <code>enum</code> <code>project</code> - which project is it related to
* <code>string</code> <code>md5</code> - to avoid sending it to pdiff to start with

imageHistory
------------
* <code>string</code> <code>path</code> - relative path from standard directory, <strong>part of primary key</strong>
* <code>enum</code> <code>state</code> - approved/pending, <strong>part of primary key</strong>
* <code>timestamp</code> <code>time</code> - when the action was performed, <strong>part of primary key</strong>
* <code>string</code> <code>action</code> - the action performed on that image, might be optimized into enum later.

user
----
* <code>string</code> <code>email</code> <code>unique</code> - user id, <strong>primary key</strong>
* <code>string</code> <code>name</code> - user selected pretty name.
* <code>int(1)</code> <code>notify</code> - 1/0 - send email notifications or not(1 = send, 0 = don't send.)

project
-------
* <code>int</code> <code>project</code> - a unique identifier per project, matches enums in image and imageHistory. <strong>primary key</strong>
* <code>string</code> <code>name</code> - the name of the project.

projectRole
-----------
* <code>string</code> <code>email</code> - user who owns the privilege
* <code>enum</code> <code>project</code> - project which the privilege applies to
* <code>enum</code> <code>privilege</code> - what kind of privilege that we approve

