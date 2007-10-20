#!/usr/bin/perl
require "include.pl";
require "functions.pl";

$query = new CGI;

#do we have an id?
if($query->param('id'))
{
	#connect to db
	$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);

	#check if video with requested id is in the database
	my $sth = $dbh->prepare(qq{select title from videos where id = ? });
	$sth->execute($query->param('id'));
	
	if(($title) = $sth->fetchrow_array())
	{
		#are we only watching this video or downloading it?
		if($query->param('view'))
		{
			#seems we only want to watch it - update viewcount
			$sth = $dbh->prepare(qq{update videos set viewcount=viewcount+1 where id = ? });
			$sth->execute($query->param('id'));
			
			print $query->header(-type=>'application/ogg');
		}
		else
		{
			#video is being downloaded - update downloadcount
			$sth = $dbh->prepare(qq{update videos set downloadcount=downloadcount+1 where id = ? });
			$sth->execute($query->param('id'));
			
			print $query->header(-type=>'application/x-download',
						-attachment=>$title.".ogg");
		}
		
		#in both cases - do some slurp-eaze to the browser
		open(FILE, "<$gnutube_root/videos/".$query->param('id'));
		print <FILE>;
		close(FILE);
	}
	else
	{
		#the requested id doesn't exist
		print $session->header();
		print "this video doesn't exist";
	}
	
	#disconnect db
	$dbh->disconnect();
}
else
{
	#if not, print error
	print $session->header();
	print "you stupid moron forgot to pass an id...";
}
