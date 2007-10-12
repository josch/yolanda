#!/usr/bin/perl
require "include.pl";

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
	#print login form
	print $session->header();
	print '<form action="" method="POST"><p>
<input name="action" type="hidden" value="login">
<input name="user" type="text" size="30" maxlength="30">
<input name="pass" type="password" size="30" maxlength="30">
<input type="submit" name="login" value=" login ">
</p></form>';
}
