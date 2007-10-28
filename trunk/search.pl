require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

$username = get_username_from_sid($session->id);

%page = ();

$page->{'username'} = $username;
$page->{'locale'} = $locale;
$page->{'stylesheet'} = $stylesheet;
$page->{'xmlns:dc'} = $xmlns_dc;
$page->{'xmlns:cc'} = $xmlns_cc;
$page->{'xmlns:rdf'} = $xmlns_rdf;

#check if query is set
if($query->param('query') or $query->param('orderby'))
{
	$page->{'results'}->{'scriptname'} = 'search.pl';
	$page->{'results'}->{'argument'} = 'query';
	$page->{'results'}->{'value'} = $query->param('query');
	$page->{'results'}->{'orderby'} = $query->param('orderby');
	$page->{'results'}->{'sort'} = $query->param('sort');
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	my @args = ();
	
	#build mysql query
	$dbquery = "select v.id, v.title, v.creator, v.description, u.username, from_unixtime( v.timestamp ), v.duration, v.viewcount";
	
	if($query->param('query'))
	{
		$dbquery .= ", match(v.title, v.description, v.subject) against( ? in boolean mode) as relevance";
		$dbquery .= " from videos as v, users as u where u.id = v.userid";
		$dbquery .= " and match(v.title, v.description, v.subject) against( ? in boolean mode)";
		push @args, $query->param('query'), $query->param('query');
	}
	else
	{
		$dbquery .= " from videos as v, users as u where u.id = v.userid";
	}
	
	if($query->param('orderby'))
	{
		if($query->param('orderby') eq 'filesize')
		{
			$dbquery .= " order by v.filesize";
		}
		elsif($query->param('orderby') eq 'duration')
		{
			$dbquery .= " order by v.duration";
		}
		elsif($query->param('orderby') eq 'viewcount')
		{
			$dbquery .= " order by v.viewcount";
		}
		elsif($query->param('orderby') eq 'downloadcount')
		{
			$dbquery .= " order by v.downloadcount";
		}
		elsif($query->param('orderby') eq 'timestamp')
		{
			$dbquery .= " order by v.timestamp";
		}
		elsif($query->param('orderby') eq 'relevance' and $query->param('query'))
		{
			$dbquery .= " order by relevance";
		}
		else
		{
			$dbquery .= " order by v.id";
		}
		
		if($query->param('sort') eq "asc")
		{
			$dbquery .= " asc"
		}
		else
		{
			$dbquery .= " desc"
		}
	}
	
	#prepare query
	my $sth = $dbh->prepare($dbquery) or die $dbh->errstr;
	
	#execute it
	$resultcount = $sth->execute(@args) or die $dbh->errstr;
	
	$pagesize = $query->param('pagesize') or $pagesize = 5;
	
	#rediculous but funny round up, will fail with 100000000000000 results per page
	#on 0.0000000000001% of all queries - this is a risk we can handle
	$lastpage = int($resultcount/$pagesize+0.99999999999999);
	
	$currentpage = $query->param('page') or $currentpage = 1;
	
	$dbquery .= " limit ".($currentpage-1)*$pagesize.", ".$pagesize;
	
	#prepare query
	$sth = $dbh->prepare($dbquery) or die $dbh->errstr;
	
	#execute it
	$sth->execute(@args) or die $dbquery;
	
	$page->{'results'}->{'lastpage'} = $lastpage;
	$page->{'results'}->{'currentpage'} = $currentpage;
	$page->{'results'}->{'resultcount'} = $resultcount;
	$page->{'results'}->{'pagesize'} = $pagesize;
	
	#get every returned value
	while (my ($id, $title, $creator, $description, $publisher, $timestamp, $duration, $viewcount, $relevance) = $sth->fetchrow_array())
	{
		#before code cleanup, this was a really obfuscated array/hash creation
		push @{ $page->{'results'}->{'result'} },
		{
			'thumbnail'		=> "./video-stills/$id",
			'duration'		=> $duration,
			'viewcount'		=> $viewcount,
			'edit'			=> $username eq $publisher ? "true" : "false",
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
else
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
}

#print xml http header along with session cookie
print $session->header(-type=>'text/xml', -charset=>'UTF-8');

#print xml
print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => '1');
