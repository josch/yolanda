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
	$page->{'username'} = get_username_from_sid($session->id);
	$page->{'locale'} = $locale;
	$page->{'stylesheet'} = $stylesheet;
	$page->{'xmlns:dc'} = $xmlns_dc;
	$page->{'xmlns:cc'} = $xmlns_cc;
	$page->{'xmlns:rdf'} = $xmlns_rdf;
	$page->{uploadform} = {'page' => '2'};

	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml', -charset=>'UTF-8');

	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
else
{
	%page = ();
	
	$page->{'username'} = get_username_from_sid($session->id);
	$page->{'locale'} = $locale;
	$page->{'stylesheet'} = $stylesheet;
	$page->{'xmlns:dc'} = $xmlns_dc;
	$page->{'xmlns:cc'} = $xmlns_cc;
	$page->{'xmlns:rdf'} = $xmlns_rdf;
	
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
	
	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml', -charset=>'UTF-8');

	#print xml
	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
