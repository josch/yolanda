#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
$query = new CGI;
my $session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

if($userinfo->{'username'})
{
	if($query->param('2'))
	{
		$page->{uploadform} = {'page' => '2'};
	}
	elsif($query->param('3'))
	{
		$page->{uploadform} = {'page' => '3'};
	}
	elsif($query->param('4'))
	{
		$page->{uploadform} = {'page' => '4'};
	}
	elsif($query->param('5'))
	{
		$page->{uploadform} = {'page' => '5'};
	}
	elsif($query->param('6'))
	{
		$page->{uploadform} = {'page' => '6'};
	}
	else
	{
		$page->{uploadform} = {'page' => '1'};
	}
}
else
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
}

#print xml http header along with session cookie
print $session->header(-type=>'text/xml', -charset=>'UTF-8');

print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => '1');
