#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
my $session = new CGI::Session;

#read xml
$page = XMLin("$gnutube_root/index.xml", ForceArray => 1, KeyAttr => {} );

#if a username is associated with session id, username is nonempty
$page->{username} = get_username_from_sid($session->id);

fill_tagcloud;

#print xml http header along with session cookie
print $session->header(-type=>'text/xml');

#print xml
print XMLout($page, KeyAttr => {}, XMLDecl => '<?xml version="1.0" encoding="ISO-8859-1" ?><?xml-stylesheet type="text/xsl" href="./xsl/xhtml.xsl" ?>', RootName => 'page');


