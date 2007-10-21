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
		#if referer is not the local site update referer table
		$referer = $query->referer() or $referer = '';
		$server_name = $query->server_name();
		if($referer !~ /^\w+:\/\/$server_name/)
		{
			#check if already in database
			$sth = $dbh->prepare(qq{select 1 from referer where videoid = ? and referer = ? }) or die $dbh->errstr;
			my $rowcount = $sth->execute($query->param('id'), $referer) or die $dbh->errstr;
			$sth->finish() or die $dbh->errstr;
			
			if($rowcount > 0)
			{
				#video is in database - increase referercount
				$sth = $dbh->prepare(qq{update referer set count=count+1 where videoid = ? and referer = ? }) or die $dbh->errstr;
				$sth->execute($query->param('id'), $referer) or die $dbh->errstr;
				$sth->finish();
			}
			else
			{
				#add new referer
				$sth = $dbh->prepare(qq{insert into referer (videoid, referer) values (?, ?) }) or die $dbh->errstr;
				$sth->execute($query->param('id'), $referer) or die $dbh->errstr;
				$sth->finish();
			}
		}
		
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
