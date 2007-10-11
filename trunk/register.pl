#!/usr/bin/perl
require "include.pl";
require "functions.pl";

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

	$page = XMLin("$gnutube_root/register.xml", ForceArray => 1, KeyAttr => {} );

	#if a username is associated with session id, username is nonempty
	$page->{username} = get_username_from_sid($session->id);

	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml');

	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
