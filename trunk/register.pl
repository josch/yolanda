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
	
	#do query
	$dbh->de(qq{insert into users (username, password) values ( ?, password( ? ))}, undef,
			$query->param("user"), $query->param("pass")) or die $dbh->errstr;

	#disconnect db
	$dbh->disconnect() or die $dbh->errstr;
	
	#print a little confirmation
	print $session->header();
	print 'done';
}
else
{
	#if not, print register form

	%page = ();

	#if a username is associated with session id, username is nonempty
	$page->{username} = get_username_from_sid($session->id);
	$page->{locale} = $locale;
	$page->{stylesheet} = $stylesheet;
	$page->{registerform} = [''];

	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml', -charset=>'UTF-8');

	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
