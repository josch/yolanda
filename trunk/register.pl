#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

#check if user is logged in
if($username)
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_already_registered";
}
#if username and password are passed put them into the database
elsif($query->param('user') and $query->param('pass') and $query->param('pass_repeat'))
{
	if($query->param('pass') eq $query->param('pass_repeat'))
	{
		#connect to db
		my $dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass) or die $dbh->errstr;
	
		#do query
		$dbh->do(qq{insert into users (username, password, timestamp, locale) values ( ?, password( ? ), unix_timestamp(), ?)}, undef,
				$query->param("user"), $query->param("pass"), $page->{'locale'}) or die $dbh->errstr;

		#disconnect db
		$dbh->disconnect() or die $dbh->errstr;
	
		#print a little confirmation
		$page->{'message'}->{'type'} = "information";
		$page->{'message'}->{'text'} = "information_registered";
	}
	else
	{
		$page->{'registerform'} = [''];
		$page->{'message'}->{'type'} = "error";
		$page->{'message'}->{'text'} = "error_passwords_do_not_match";
	}
}
elsif(not $query->param('user') and ($query->param('pass') or $query->param('pass_repeat')))
{
	$page->{'registerform'} = [''];
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_insert_username";
}
elsif(not $query->param('pass') and ($query->param('user') or $query->param('pass_repeat')))
{
	$page->{'registerform'} = [''];
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_insert_password";
}
elsif(not $query->param('pass_repeat') and ($query->param('user') or $query->param('pass')))
{
	$page->{'registerform'} = [''];
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_repeat_password";
}
else
{
	$page->{'registerform'} = [''];
}

#print xml http header along with session cookie
print $session->header(-type=>'text/xml', -charset=>'UTF-8');

print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => '1');
