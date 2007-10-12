#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
my $session = new CGI::Session;

%page = ();

#if a username is associated with session id, username is nonempty
$page->{username} = get_username_from_sid($session->id);
$page->{locale} = $locale;
$page->{stylesheet} = $stylesheet;
$page->{frontpage} = [''];

fill_tagcloud;

#print xml http header along with session cookie
print $session->header(-type=>'text/xml');

#print xml
print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');

