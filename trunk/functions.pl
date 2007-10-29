#!/usr/bin/perl
require "include.pl";

#get tags from database and fill $page with xml
sub fill_tagcloud
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select text, count from tagcloud }) or die $dbh->errstr;
	
	#execute it
	$sth->execute() or die $dbh->errstr;
	
	#get every returned value
	while (my ($text, $count) = $sth->fetchrow_array())
	{
		#push the new value to the $page->tagcloud array
		push @{ $page->{tagcloud}->{tag} }, { text => [$text], count => [$count] };
	}
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
}

sub get_userinfo_from_sid
{
	#get parameters
	my ($sid) = @_;
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select id, username, locale, pagesize, cortado from users where sid = ?}) or die $dbh->errstr;
	
	#execute it
	$sth->execute($sid) or die $dbh->errstr;
	
	#save the resulting username
	($userinfo->{'id'}, $userinfo->{'username'}, $userinfo->{'locale'}, $userinfo->{'pagesize'}, $userinfo->{'cortado'}) = $sth->fetchrow_array();
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
	
	#return 
	return @userinfo;
}

sub get_page_array
{
	#get parameters
	my (@userinfo) = @_;
	
	$page->{'username'} = $userinfo->{'username'};
	#if user is logged in, use his locale setting
	if($userinfo->{'locale'})
	{
		$page->{'locale'} = $userinfo->{'locale'};
	}
	#else get the locale from the http server variable
	else
	{
		($page->{'locale'}) = $query->http('HTTP_ACCEPT_LANGUAGE') =~ /^([^,]+),.*$/;
	}
	$page->{stylesheet} = $stylesheet;
	$page->{'xmlns:dc'} = $xmlns_dc;
	$page->{'xmlns:cc'} = $xmlns_cc;
	$page->{'xmlns:rdf'} = $xmlns_rdf;
}

sub fill_results
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare($dbquery) or die $dbh->errstr;
	
	#execute it
	$resultcount = $sth->execute(@_) or die $dbh->errstr;
	
	$pagesize = $query->param('pagesize') or $pagesize = 5;
	
	#rediculous but funny round up, will fail with 100000000000000 results per page
	#on 0.0000000000001% of all queries - this is a risk we can handle
	$lastpage = int($resultcount/$pagesize+0.99999999999999);
	
	$currentpage = $query->param('page') or $currentpage = 1;
	
	$dbquery .= " limit ".($currentpage-1)*$pagesize.", ".$pagesize;
	
	#prepare query
	$sth = $dbh->prepare($dbquery) or die $dbh->errstr;
	
	#execute it
	$sth->execute(@_) or die $dbquery;
	
	$page->{'results'}->{'lastpage'} = $lastpage;
	$page->{'results'}->{'currentpage'} = $currentpage;
	$page->{'results'}->{'resultcount'} = $resultcount eq '0E0' ? 0 : $resultcount;
	$page->{'results'}->{'pagesize'} = $pagesize;
	
	#get every returned value
	while (my ($id, $title, $description, $publisher, $timestamp, $creator, $subject,
			$contributor, $source, $language, $coverage, $rights, $license,
			$filesize, $duration, $width, $height, $fps, $viewcount, $downloadcount) = $sth->fetchrow_array())
	{
		#before code cleanup, this was a really obfuscated array/hash creation
		push @{ $page->{'results'}->{'result'} },
		{
			'thumbnail'		=> "/video-stills/$id",
			'duration'		=> $duration,
			'viewcount'		=> $viewcount,
			'edit'			=> $userinfo->{'username'} eq $publisher ? "true" : "false",
			'rdf:RDF'		=>
			{
				'cc:Work'		=>
				{
					'rdf:about'			=> "$domain/download/$id",
					'dc:title'			=> [$title],
					'dc:creator'		=> [$creator],
					'dc:date'			=> [$timestamp],
					'dc:identifier'		=> ["$domain/video/$title/$id"],
					'dc:publisher'		=> [$publisher]
				},
				'cc:License'	=>
				{
					'rdf:about' 	=> 'http://creativecommons.org/licenses/GPL/2.0/'
				}
			}
		};
	}
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
}
