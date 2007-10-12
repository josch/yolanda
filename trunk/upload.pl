#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
my $session = new CGI::Session;

my $username = get_username_from_sid($session->id);

if($username)
{
	%page = ();

	#if a username is associated with session id, username is nonempty
	$page->{username} = get_username_from_sid($session->id);
	$page->{locale} = $locale;
	$page->{stylesheet} = $stylesheet;
	$page->{uploadform} = [''];

	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml');

	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
else
{
	print $session->header();
	print "nope...";
}
