#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
my $session = new CGI::Session;

my $username = get_username_from_sid($session->id);

if($username)
{
	print $session->header();
	print '<form action="uploader.pl" method="post" enctype="multipart/form-data">
Upload: <input type="file" name="file">
<br><br>
Title: <input type="text" name="title">
<br><br>
Beschreibung: <input type="text" name="caption">
<br><br>
<input type="submit" name="submit" value=" upload ">
</form>';
}
else
{
	print $session->header();
	print "nope...";
}
