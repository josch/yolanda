require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#check if query is set
if($query->param('query'))
{
	my $search_query = $query->param('query');

	$page = XMLin("$gnutube_root/search.xml", ForceArray => 1, KeyAttr => {} );
	
	#if a username is associated with session id, username is nonempty
	$page->{username} = get_username_from_sid($session->id);
	
	$page->{results}->{query} = $query->param('query');
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select title, caption, timestamp from videos where match(title, caption) against('$search_query') }) or die $dbh->errstr;
	
	#execute it
	$sth->execute() or die $dbh->errstr;
	
	#get every returned value
	while (my ($title, $caption, $timestamp) = $sth->fetchrow_array())
	{
		#really obfuscated array/hash creation
		push @{ $page->{'results'}->{'result'} },
		{
			'thumbnail' => ['./video-stills/225x150/4chan_city_mashup.png'],
			'rdf:RDF' =>
			{
				'cc:Work' =>
				{
					'rdf:about' => './videos/1050x700/4chan_city_mashup.ogg',
					'dc:title' => [$title],
					'dc:date' => [$timestamp]
				},
				'cc:License' =>
				{
					'rdf:about' => 'http://creativecommons.org/licenses/GPL/2.0/'
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
	print XMLout($page, KeyAttr => {}, XMLDecl => '<?xml version="1.0" encoding="ISO-8859-1" ?><?xml-stylesheet type="text/xsl" href="./xsl/xhtml.xsl" ?>', RootName => 'page');
}
else
{
	print $session->header();
	print "no query passed";
}
