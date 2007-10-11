#!/usr/bin/perl
require "include.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#if username and password are passed put them into the database
if($query->param('user') and $query->param('pass'))
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass) or die $dbh->errstr;
	
	#save POST data in local variables
	my $user = $query->param("user");
	my $pass = $query->param("pass");
	
	#do query
	$dbh->do(qq{insert into users (username, password) values ('$user', password('$pass'))}) or die $dbh->errstr;

	#disconnect db
	$dbh->disconnect() or die $dbh->errstr;
	
	#print a little confirmation
	print $session->header();
	print 'done';
}
else
{
	#if not, print register form
	print $session->header();
	print '<?xml version="1.0" encoding="ISO-8859-1" ?>';			# josch, sanitize this
	print '<?xml-stylesheet type="text/xsl" href="./xsl/xhtml.xsl" ?>';			# josch, sanitize this
	print '<page locale="en-US" stylesheet="./style/gnutube.css" username="">';				# josch, sanitize this
	print '<registerform />';
	print '</page>';				# josch, sanitize this
}
