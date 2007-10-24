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
		#prepare query - empty password are openid users so omit those entries
		my $sth = $dbh->prepare(qq{select id from users
				where password = password( ? ) and username = ? and not password = '' limit 1 });
				
		#execute query
		$sth->execute($query->param('pass'), $query->param('user'));
		
		#if something was returned username and password match
		if($sth->fetchrow_array())
		{
			#store session id in database
			$dbh->do(qq{update users set sid = ? where username = ? }, undef, $session->id, $query->param('user')) or die $dbh->errstr;
			print $query->redirect("index.pl?information=information_logged_in");
		}
		else
		{
			#if not, print error
			print $session->header();
			print "could not log you in";
		}
		
	}
	elsif($query->param('action') eq "openid")
	{
		#create our openid consumer object
		$con = Net::OpenID::Consumer->new(
		ua => LWP::UserAgent->new, # FIXME - use LWPx::ParanoidAgent
		cache => undef, # or File::Cache->new,
		args => $query,
		consumer_secret => $session->id, #is this save? don't know...
		required_root => "http://localhost/" );
		
		#is an openid passed?
		if($query->param('user'))
		{
			#claim identity
			$claimed = $con->claimed_identity($query->param('user'));
			if(!defined($claimed))
			{
				print $session->header();
				print "claim failed: ", $con->err;
			}
			$check_url = $claimed->check_url(
					return_to  => "http://localhost/gnutube/login.pl?action=openid&ret=true", #on success return to this address
					trust_root => "http://localhost/"); #this is the string the user will be asked to trust
					
			#redirect to openid server to check claim
			print $query->redirect($check_url);
		}
		#we return from an identity check
		elsif($query->param('ret'))
		{
			if($setup_url = $con->user_setup_url)
			{
				#redirect to setup url - user will give confirmation there
				print $query->redirect($setup_url);
			}
			elsif ($con->user_cancel)
			{
				#cancelled - redirect to login form
				print $session->header();
				print "cancelled";
			}
			elsif ($vident = $con->verified_identity)
			{
				#we are verified!!
				my $verified_url = $vident->url;
				
				#check if this openid user already is in database
				my $sth = $dbh->prepare(qq{select 1 from users where username = ? limit 1 });
				$sth->execute($verified_url);
				if($sth->fetchrow_array())
				{
					#store session id in database
					$dbh->do(qq{update users set sid = ? where username = ? }, undef, $session->id, $verified_url) or die $dbh->errstr;
				}
				else
				{
					#add openid user to dabase
					$dbh->do(qq{insert into users (username, sid) values ( ?, ? ) }, undef, $verified_url, $session->id) or die $dbh->errstr;
				}
				
				print $query->redirect("index.pl?information=information_logged_in");
			}
			else
			{
				#an error occured
				print $session->header();
				print "error validating identity: ", $con->err;
			}
		}
		else
		{
			#someone is messing with the args
			print $session->header();
			print "hmm, openid action but no ret or user";
		}
	}
	elsif($query->param('action') eq "logout")
	{
		#if logout is requested
		#remove sid from database
		$dbh->do(qq{update users set sid = '' where username = ?}, undef, get_username_from_sid($session->id)) or die $dbh->errstr;
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

	%page = ();

	#if a username is associated with session id, username is nonempty
	$page->{username} = get_username_from_sid($session->id);
	$page->{locale} = $locale;
	$page->{stylesheet} = $stylesheet;
	$page->{loginform} = [''];

	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml');

	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
