require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#check if query is set
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
		#prepare query
		$sth = $dbh->prepare(qq{select id, title, caption, userid, timestamp from videos where id = ? }) or die $dbh->errstr;
		#execute it
		$rowcount = $sth->execute($query->param('id')) or die $dbh->errstr;
	}
	else
	{
		#prepare query
		$sth = $dbh->prepare(qq{select id, title, caption, userid, timestamp from videos where title = ? and status = 1 }) or die $dbh->errstr;
		#execute it
		$rowcount = $sth->execute($query->param('title')) or die $dbh->errstr;
	}
	
	if($rowcount == 1)
	{
		my ($id, $title, $caption, $userid, $timestamp) = $sth->fetchrow_array();

		#before code cleanup, this was a really obfuscated array/hash creation
		push @{ $page->{'video'} },
		{
			'thumbnail'		=> ['./video-stills/225x150/4chan_city_mashup.png'],
			'rdf:RDF'		=>
			{
				'cc:Work'		=>
				{
					'rdf:about'		=> "./videos/".$query->param('id'),
					'dc:title'		=> [$title],
					'dc:date'		=> [$timestamp],
					'dc:publisher'	=> [get_username_from_id($userid)],
					'dc:description'=> [$caption]
				},
				'cc:License'	=>
				{
					'rdf:about' 	=> 'http://creativecommons.org/licenses/GPL/2.0/'
				}
			}
		};
	}
	else
	{
		$page->{results}->{query} = decode_utf8($query->param('title'));
		#get every returned value
		while (my ($id, $title, $caption, $userid, $timestamp) = $sth->fetchrow_array())
		{
			#before code cleanup, this was a really obfuscated array/hash creation
			push @{ $page->{'results'}->{'result'} },
			{
				'thumbnail'		=> ['./video-stills/225x150/4chan_city_mashup.png'],
				'rdf:RDF'		=>
				{
					'cc:Work'		=>
					{
						'rdf:about'		=> "./video.pl?title=$title&id=$id",
						'dc:title'		=> [$title],
						'dc:date'		=> [$timestamp],
						'dc:publisher'	=> [get_username_from_id($userid)],
						'dc:description'=> [$caption]
					},
					'cc:License'	=>
					{
						'rdf:about' 	=> 'http://creativecommons.org/licenses/GPL/2.0/'
					}
				}
			};
		}
	}
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
	
	#print xml http header along with session cookie
	print $session->header(-type=>'text/xml');

	#print xml
	print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page');
}
else
{
	print $session->header();
	print "no query passed";
}
