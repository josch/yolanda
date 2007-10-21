require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#check if id or title is passed
if($query->param('title') or $query->param('id'))
{
	%page = ();
	
	#if a username is associated with session id, username is nonempty
	$page->{'username'} = get_username_from_sid($session->id);
	$page->{'locale'} = $locale;
	$page->{'stylesheet'} = $stylesheet;
	$page->{'xmlns:dc'} = $xmlns_dc;
	$page->{'xmlns:cc'} = $xmlns_cc;
	$page->{'xmlns:rdf'} = $xmlns_rdf;
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	if($query->param('id'))
	{
		#if id is passed ignore title and check for the id
		$sth = $dbh->prepare(qq{select id, title, description, userid, from_unixtime( timestamp ),
							creator, subject, contributor, source, language, coverage, rights, license
							from videos where id = ? }) or die $dbh->errstr;
		$rowcount = $sth->execute($query->param('id')) or die $dbh->errstr;
	}
	else
	{
		#if no id was passed there has to be a title we search for
		$sth = $dbh->prepare(qq{select id, title, description, userid, from_unixtime( timestamp ),
							creator, subject, contributor, source, language, coverage, rights, license
							from videos where title = ? }) or die $dbh->errstr;
		$rowcount = $sth->execute($query->param('title')) or die $dbh->errstr;
	}
	
	#if the args are wrong there my be zero results
	#if there was a title passed, then perform a search
	if($rowcount == 0 and $query->param('title'))
	{
		$sth = $dbh->prepare(qq{select id, title, description, userid, from_unixtime( timestamp ),
							creator, subject, contributor, source, language, coverage, rights, license
							from videos where match(title, description, subject) against( ? ) }) or die $dbh->errstr;
		$rowcount = $sth->execute($query->param('title')) or die $dbh->errstr;
	}
	
	if($rowcount == 0)
	{
		#still no results
		#there is nothing we can do now - this video doesn't exist...	
		$page->{'message'}->{'type'} = "error";
		$page->{'message'}->{'text'} = "error_202c";
	}
	elsif($rowcount == 1)
	{
		#if there was a single result, display the video
		my ($title, $description, $userid, $timestamp, $creator, $subject,
			$contributor, $source, $language, $coverage, $rights, $license,) = $sth->fetchrow_array();
		
		#finish query
		$sth->finish() or die $dbh->errstr;
		
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
		
		#before code cleanup, this was a really obfuscated array/hash creation
		push @{ $page->{'video'} },
		{
			'thumbnail'		=> ['./video-stills/225x150/4chan_city_mashup.png'],
			'rdf:RDF'		=>
			{
				'cc:Work'		=>
				{
					'rdf:about'			=> "./videos/".$query->param('id'),
					'dc:title'			=> [$title],
					'dc:creator'		=> [$creator],
					'dc:subject'		=> [$subject],
					'dc:description'	=> [$description],
					'dc:publisher'		=> [get_username_from_id($userid)],
					'dc:contributor'	=> [$contributor],
					'dc:date'			=> [$timestamp],
					'dc:identifier'		=> ["./videos/".$query->param('id')],
					'dc:source'			=> [$source],
					'dc:language'		=> [$language],
					'dc:coverage'		=> [$coverage],
					'dc:rights'			=> [$rights]
				},
				'cc:License'	=>
				{
					'rdf:about' 	=> $license
				}
			}
		};
	}
	else
	{
		#when an ambigous title was passed there may me many results - display them like search.pl does
		$page->{results}->{query} = decode_utf8($query->param('title'));
		#get every returned value
		while (my ($title, $description, $userid, $timestamp) = $sth->fetchrow_array())
		{
			#before code cleanup, this was a really obfuscated array/hash creation
			push @{ $page->{'results'}->{'result'} },
			{
				'thumbnail'		=> ['./video-stills/225x150/4chan_city_mashup.png'],
				'rdf:RDF'		=>
				{
					'cc:Work'		=>
					{
						'rdf:about'		=> "./video.pl?title=$title&id=".$query->param('id'),
						'dc:title'		=> [$title],
						'dc:date'		=> [$timestamp],
						'dc:publisher'	=> [get_username_from_id($userid)],
						'dc:description'=> [$description]
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
	}
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
	
	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml');

	#print xml
	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
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
