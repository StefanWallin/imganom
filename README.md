Current Status
==============

This project is just started as of 2012-08-22. The only asset currently existing is this project outline. Leave a comment on it if you have any opinions!

imganom
=======
Utility to detect anomalies in two images that should be the same, useful for GUI testing.
The utility is two parted:
* a REST-based API for integration in your test suite.
* a web client for approving or disapproving images.

HTTP REST Protocol
==================

PUT /test/imagename
--------------------
Compares the uploaded image on that URL with a previous image uploaded on the same url. Uses <a href="http://pdiff.sourceforge.net/">pdiff / PerceptualDiff</a> for image comparison backend.
Returns: 
* <code>409 Conflict</code> - if the image is not identical with the old one(according to pdiff). 
* <code>201 Created</code> - if the image does not exist, that is, this is the first image with this name.
* <code>304 Not Modified</code> - if the image is identical with the previously approved image.

Regardless of the response, the server also returns stringified JSON with this structure:
<pre><code>
	{
		"status": numeric_response_code,
		"url": web_gui_url
	}
</code></pre>
