require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#check if id or title is passed
if($query->url_param('title') or $query->url_param('id'))
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
	
	if($query->url_param('id'))
	{
		#if id is passed ignore title and check for the id
		$sth = $dbh->prepare(qq{select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ),
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, filesize, duration, width, height, fps, viewcount,
							downloadcount
							from videos as v, users as u where v.id = ? and u.id=v.userid }) or die $dbh->errstr;
		$rowcount = $sth->execute($query->url_param('id')) or die $dbh->errstr;
	}
	else
	{
		#if no id was passed there has to be a title we search for
		$sth = $dbh->prepare(qq{select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ),
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, filesize, duration, width, height, fps, viewcount,
							downloadcount
							from videos as v, users as u where v.title = ? and u.id=v.userid }) or die $dbh->errstr;
		$rowcount = $sth->execute($query->url_param('title')) or die $dbh->errstr;
	}
	
	#if the args are wrong there my be zero results
	#if there was a title passed, then perform a search
	if($rowcount == 0 and $query->url_param('title'))
	{
		$sth = $dbh->prepare(qq{select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ),
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, filesize, duration, width, height, fps, viewcount,
							downloadcount
							from videos as v, users as u where match(v.title, v.description, v.subject) against( ? )
							and u.id=v.userid }) or die $dbh->errstr;
		$rowcount = $sth->execute($query->url_param('title')) or die $dbh->errstr;
	}
	
	#from this point on, do not use $query->param('id') anymore - we do not know what was given
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
		my ($id, $title, $description, $username, $timestamp, $creator, $subject,
			$contributor, $source, $language, $coverage, $rights, $license,
			$filesize, $duration, $width, $height, $fps, $viewcount, $downloadcount) = $sth->fetchrow_array();
		
		#finish query
		$sth->finish() or die $dbh->errstr;
		
		#if user is logged in
		if($userid = get_userid_from_sid($session->id))
		{
			#check if a comment is about to be created
			if($query->param('comment'))
			{
				#output infobox
				$page->{'message'}->{'type'} = "information";
				$page->{'message'}->{'text'} = "information_comment_created";
			
				#add to database
				$dbh->do(qq{insert into comments (userid, videoid, text, timestamp) values (?, ?, ?, unix_timestamp())}, undef, $userid, $id, $query->param('comment')) or die $dbh->errstr;
			}
		}
		
		#if referer is not the local site update referer table
		$referer = $query->referer() or $referer = '';
		$server_name = $query->server_name();
		if($referer !~ /^\w+:\/\/$server_name/)
		{
			#check if already in database
			$sth = $dbh->prepare(qq{select 1 from referer where videoid = ? and referer = ? }) or die $dbh->errstr;
			my $rowcount = $sth->execute($id, $referer) or die $dbh->errstr;
			$sth->finish() or die $dbh->errstr;
			
			if($rowcount > 0)
			{
				#video is in database - increase referercount
				$dbh->do(qq{update referer set count=count+1 where videoid = ? and referer = ? }, undef, $id, $referer) or die $dbh->errstr;
			}
			else
			{
				#add new referer
				$dbh->do(qq{insert into referer (videoid, referer) values (?, ?) }, undef, $id, $referer) or die $dbh->errstr;
			}
		}
		
		#before code cleanup, this was a really obfuscated array/hash creation
		push @{ $page->{'video'} },
		{
			'thumbnail'		=> "$domain/video-stills/$id",
			'cortado'		=> $query->param('cortado') eq 'false' ? "false" : "true",
			'filesize'		=> $filesize,
			'duration'		=> $duration,
			'width'			=> $width,
			'height'		=> $height,
			'fps'			=> $fps,
			'viewcount'		=> $viewcount,
			'downloadcount'	=> $downloadcount,
			'rdf:RDF'		=>
			{
				'cc:Work'		=>
				{
					'rdf:about'			=> "$domain/download/$id",
					'dc:title'			=> [$title],
					'dc:creator'		=> [$creator],
					'dc:subject'		=> [$subject],
					'dc:description'	=> [$description],
					'dc:publisher'		=> [$username],
					'dc:contributor'	=> [$contributor],
					'dc:date'			=> [$timestamp],
					'dc:identifier'		=> ["$domain/video/$title/$id"],
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
		
		#get comments
		$sth = $dbh->prepare(qq{select comments.id, comments.text, users.username, from_unixtime( comments.timestamp )
								from comments, users where
								comments.videoid=? and users.id=comments.userid}) or die $dbh->errstr;
		$sth->execute($id) or die $dbh->errstr;
		while (my ($commentid, $text, $username, $timestamp) = $sth->fetchrow_array())
		{
			push @{ $page->{'comments'}->{'comment'} }, {
				'text'	=> [$text],
				'username'	=> $username,
				'timestamp' => $timestamp,
				'id'		=> $commentid
			};
		}
		
		#get referers
		$sth = $dbh->prepare(qq{select count, referer from referer where videoid=?}) or die $dbh->errstr;
		$sth->execute($id) or die $dbh->errstr;
		while (my ($count, $referer) = $sth->fetchrow_array())
		{
			$referer or $referer = 'no referer (refreshed, manually entered url or bookmark)';
			push @{ $page->{'referers'}->{'referer'} }, {
				'count'		=> $count,
				'referer'	=> $referer
			};
		}
	}
	else
	{
		#when an ambigous title was passed there may me many results - display them like search.pl does
		$page->{results}->{query} = $query->url_param('title');
		#get every returned value
		while (my ($id, $title, $description, $userid, $timestamp) = $sth->fetchrow_array())
		{
			#before code cleanup, this was a really obfuscated array/hash creation
			push @{ $page->{'results'}->{'result'} },
			{
				'thumbnail'		=> ['./video-stills/225x150/4chan_city_mashup.png'],
				'rdf:RDF'		=>
				{
					'cc:Work'		=>
					{
						'rdf:about'		=> "./video.pl?title=$title&id=".$id,
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
	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => 1);
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
