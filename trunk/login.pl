#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#check if action is set
if($query->param('action'))
{
	#connect to db
	$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);
	
	#if login is requested
	if($query->param('action') eq "login")
	{
		#prepare query
		my $sth = $dbh->prepare(qq{select username from users
				where password = password( ? )
				and username = ?
				limit 1 });
				
		#execute query
		$sth->execute($query->param('pass'), $query->param('user'));
		
		#if something was returned username and password match
		if($sth->fetchrow_array())
		{
			#store session id in database
			$sth = $dbh->prepare(qq{update users set sid = ? where username = ? }); 
			$sth->execute($session->id, $query->param('user'));
			$sth->finish();
			print $session->header();
			print "logged in";
		}
		else
		{
			#if not, print error
			print $session->header();
			print "could not log you in";
		}
		
	}
	elsif($query->param('action') eq "logout")
	{
		#if logout is requested
		#remove sid from database
		$sth = $dbh->prepare(qq{update users set sid = '' where username = ?});
		$sth->execute(get_username_from_sid($session->id));
		$sth->finish();
		$session->delete();
		print $session->header();
		print "logged out";
	}
	else
	{
		#something ugly was passed
		print $session->header();
		print "wtf?";
	}

	#disconnect db
	$dbh->disconnect();
}
else
{
	#if not, print login form

	$page = XMLin("$gnutube_root/login.xml", ForceArray => 1, KeyAttr => {} );

	#if a username is associated with session id, username is nonempty
	$page->{username} = get_username_from_sid($session->id);

	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml');

	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
