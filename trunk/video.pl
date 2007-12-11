require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

if($query->url_param('action') eq 'edit' and $query->url_param('id'))
{
	$page->{'message'}->{'type'} = "information";
}
if($query->url_param('action') eq 'bookmark' and $query->url_param('id'))
{
	$page->{'message'}->{'type'} = "information";
}
#check if id or title is passed
elsif($query->url_param('title') or $query->url_param('id'))
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	if($query->url_param('id'))
	{
		#if id is passed ignore title and check for the id
		$dbquery = "select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ),
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, filesize, duration, width, height, fps, viewcount, downloadcount
							from videos as v, users as u where v.id = ? and u.id=v.userid";
							
		@args = ($query->url_param('id'));
	}
	else
	{
		#if no id was passed there has to be a title we search for
		$dbquery = "select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ),
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, filesize, duration, width, height, fps, viewcount, downloadcount
							from videos as v, users as u where v.title = ? and u.id=v.userid";
							
		@args = ($query->url_param('title'));
	}
	
	$sth = $dbh->prepare($dbquery);
	$rowcount = $sth->execute(@args) or die $dbh->errstr;
	
	#if the args are wrong there my be zero results
	#if there was a title passed, then perform a search
	if($rowcount == 0 and $query->url_param('title'))
	{
		$dbquery = "select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ),
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, filesize, duration, width, height, fps, viewcount, downloadcount";
		$dbquery .= ", match(v.title, v.description, v.subject) against( ? in boolean mode) as relevance";
		$dbquery .= " from videos as v, users as u where u.id = v.userid";
		$dbquery .= " and match(v.title, v.description, v.subject) against( ? in boolean mode)";
		
		@args = ($query->url_param('title'), $query->url_param('title'));
		
		$sth = $dbh->prepare($dbquery);
		$rowcount = $sth->execute(@args) or die $dbh->errstr;
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
		$page->{'embed'} = $query->param('embed') eq 'true' ? "true" : "false";
	
		#if there was a single result, display the video
		my ($id, $title, $description, $publisher, $timestamp, $creator, $subject,
			$contributor, $source, $language, $coverage, $rights, $license,
			$filesize, $duration, $width, $height, $fps, $viewcount, $downloadcount) = $sth->fetchrow_array();
		
		#finish query
		$sth->finish() or die $dbh->errstr;
		
		#if user is logged in
		if($userinfo->{'username'})
		{
			#check if a comment is about to be created
			if($query->param('comment'))
			{
				#output infobox
				$page->{'message'}->{'type'} = "information";
				$page->{'message'}->{'text'} = "information_comment_created";
			
				#add to database
				$dbh->do(qq{insert into comments (userid, videoid, text, timestamp) values (?, ?, ?, unix_timestamp())}, undef,
						$userinfo->{'id'}, $id, $query->param('comment')) or die $dbh->errstr;
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
			'edit'			=> $userinfo->{'username'} eq $publisher ? "true" : "false",
			'rdf:RDF'		=>
			{
				'cc:Work'		=>
				{
					'rdf:about'			=> "$domain/download/$id/",
					'dc:title'			=> [$title],
					'dc:creator'		=> [$creator],
					'dc:subject'		=> [$subject],
					'dc:description'	=> [$description],
					'dc:publisher'		=> [$publisher],
					'dc:contributor'	=> [$contributor],
					'dc:date'			=> [$timestamp],
					'dc:identifier'		=> ["$domain/video/".urlencode($title)."/$id/"],
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
		
		$page->{'results'}->{'scriptname'} = 'video.pl';
		$page->{'results'}->{'argument'} = 'title';
		$page->{'results'}->{'value'} = $query->param('title');
		$page->{'results'}->{'orderby'} = $query->param('orderby');
		$page->{'results'}->{'sort'} = $query->param('sort');
		
		$page->{'search'} = [''];
		
		fill_results(@args);
	}
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
}
else
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
}

#print xml http header along with session cookie
print $session->header(-type=>'text/xml', -charset=>'UTF-8');

#print xml
print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => '1');
