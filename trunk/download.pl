#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

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
				$dbh->do(qq{update referer set count=count+1 where videoid = ? and referer = ? },
						undef, $query->param('id'), $referer) or die $dbh->errstr;
			}
			else
			{
				#add new referer
				$dbh->do(qq{insert into referer (videoid, referer) values (?, ?) },
						undef, $query->param('id'), $referer) or die $dbh->errstr;
			}
		}
		
		#are we only watching this video or downloading it?
		if($query->param('view'))
		{
			#seems we only want to watch it - update viewcount
			$dbh->do(qq{update videos set viewcount=viewcount+1 where id = ? }, undef, $query->param('id')) or die $dbh->errstr;
			
			print $query->header(-type=>'application/ogg');
		}
		else
		{
			#video is being downloaded - update downloadcount
			$dbh->do(qq{update videos set downloadcount=downloadcount+1 where id = ? }, undef, $query->param('id')) or die $dbh->errstr;
			
			print $query->header(-type=>'application/x-download',
						-attachment=>$title.".ogv");
		}
		
		#in both cases - do some slurp-eaze to the browser
		open(FILE, "<$gnutube_root/videos/".$query->param('id'));
		print <FILE>;
		close(FILE);
	}
	else
	{
		#there is no video with this id
		%page = ();
	
		$page->{'username'} = get_username_from_sid($session->id);
		$page->{'locale'} = $locale;
		$page->{'stylesheet'} = $stylesheet;
		$page->{'xmlns:dc'} = $xmlns_dc;
		$page->{'xmlns:cc'} = $xmlns_cc;
		$page->{'xmlns:rdf'} = $xmlns_rdf;
	
		$page->{'message'}->{'type'} = "error";
		$page->{'message'}->{'text'} = "error_202c";
	
		#print xml http header along with session cookie
		print $session->header(-type=>'text/xml');

		#print xml
		print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
	}
	
	#disconnect db
	$dbh->disconnect();
}
else
{
	%page = ();
	
	#if a username is associated with session id, username is nonempty
	$page->{'username'} = get_username_from_sid($session->id);
	$page->{'locale'} = $locale;
	$page->{'stylesheet'} = $stylesheet;
	$page->{'xmlns:dc'} = $xmlns_dc;
	$page->{'xmlns:cc'} = $xmlns_cc;
	$page->{'xmlns:rdf'} = $xmlns_rdf;
	
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
	
	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml');

	#print xml
	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
