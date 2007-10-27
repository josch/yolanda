#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

$username = get_username_from_sid($session->id);

%page = ();

$page->{'username'} = $username;
$page->{'locale'} = $locale;
$page->{'stylesheet'} = $stylesheet;
$page->{'xmlns:dc'} = $xmlns_dc;
$page->{'xmlns:cc'} = $xmlns_cc;
$page->{'xmlns:rdf'} = $xmlns_rdf;

#check if user is logged in
if($username)
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_already_registered";
}
#if username and password are passed put them into the database
elsif($query->param('user') and $query->param('pass'))
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass) or die $dbh->errstr;
	
	#do query
	$dbh->de(qq{insert into users (username, password) values ( ?, password( ? ))}, undef,
			$query->param("user"), $query->param("pass")) or die $dbh->errstr;

	#disconnect db
	$dbh->disconnect() or die $dbh->errstr;
	
	#print a little confirmation
	$page->{'message'}->{'type'} = "information";
	$page->{'message'}->{'text'} = "information_registered";
}
else
{
	$page->{'registerform'} = [''];
}

#print xml http header along with session cookie
print $session->header(-type=>'text/xml', -charset=>'UTF-8');

print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => '1');
