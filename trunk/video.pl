require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#check if query is set
if($query->param('id'))
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
	
	#prepare query
	my $sth = $dbh->prepare(qq{select title, caption, userid, timestamp from videos where id = ? }) or die $dbh->errstr;
	
	#execute it
	$sth->execute($query->param('id')) or die $dbh->errstr;
	
	#get every returned value
	while (my ($title, $caption, $userid, $timestamp) = $sth->fetchrow_array())
	{
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
					'dc:publisher'	=> [get_username_from_id($userid)]
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
