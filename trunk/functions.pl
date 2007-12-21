require "include.pl";

sub get_userinfo_from_sid
{
	#get parameters
	my ($sid) = @_;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select id, username, locale, pagesize, cortado from users where sid = ?}) or die $dbh->errstr;
	
	#execute it
	$sth->execute($sid) or die $dbh->errstr;
	
	#save the resulting username
	($userinfo->{'id'}, $userinfo->{'username'}, $userinfo->{'locale'}, $userinfo->{'pagesize'}, $userinfo->{'cortado'}) = $sth->fetchrow_array();
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#return 
	return @userinfo;
}

sub get_page_array
{
	#get parameters
	my (@userinfo) = @_;
	
	#if user is logged in, use his locale setting and check for new upload status
	if($userinfo->{'username'})
	{
		$page->{'locale'} = $userinfo->{'locale'};
	}
	#else get the locale from the http server variable
	else
	{
		($page->{'locale'}) = $query->http('HTTP_ACCEPT_LANGUAGE') =~ /^([^,]+),.*$/;
	}
	
	$page->{'username'} = $userinfo->{'username'};
	$page->{'stylesheet'} = $stylesheet;
	$page->{'xmlns:dc'} = $xmlns_dc;
	$page->{'xmlns:cc'} = $xmlns_cc;
	$page->{'xmlns:rdf'} = $xmlns_rdf;
}

# called by video.pl (display ambiguous videos),
# search.pl (display search results)
# and upload.pl (display similar videos)
sub fill_results
{
	#prepare query
	my $sth = $dbh->prepare($dbquery) or die $dbh->errstr;
	
	#execute it
	$resultcount = $sth->execute(@_) or die $dbh->errstr;
	
	#set pagesize by query or usersettings or default
	$pagesize = $query->param('pagesize') or $pagesize =  $userinfo->{'pagesize'} or $pagesize = $defaultpagesize;
	
	#if pagesize is more than maxpagesize reduce to maxpagesize
	$pagesize = $pagesize > $maxpagesize ? $maxpagesize : $pagesize;
	
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
	
	if($resultcount eq '0E0')
	{
		$page->{'message'}->{'type'} = "information";
		$page->{'message'}->{'text'} = "information_no_results";
	}
	
	#get every returned value
	while (my ($id, $title, $description, $publisher, $timestamp, $creator,
		$subject, $contributor, $source, $language, $coverage, $rights,
		$license, $filesize, $duration, $width, $height, $fps, $viewcount,
		$downloadcount, $status) = $sth->fetchrow_array())
	{
		#before code cleanup, this was a really obfuscated array/hash creation
		push @{ $page->{'results'}->{'result'} },
		{
			'thumbnail'		=> $duration == 0 ? "/images/tango/video-x-generic.png" : "/video-stills/$id",
			'duration'		=> $duration,
			'viewcount'		=> $viewcount,
			'status'		=> $status,
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
					'dc:identifier'		=> ["$domain/video/".urlencode($title)."/$id/" . ($duration == 0 ? "/action=edit" : "")],
					'dc:source'			=> [$source],
					'dc:language'		=> [$language],
					'dc:coverage'		=> [$coverage],
					'dc:rights'			=> [$rights]
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

#replace chars in url as said in this rfc: http://www.rfc-editor.org/rfc/rfc1738.txt
sub urlencode
{
	my ($url) = @_[0];
	$url =~ s/([^A-Za-z0-9_\$\-.+!*'()])/sprintf("%%%02X", ord($1))/eg;
	return $url;
}

sub output_page
{
	use XML::LibXSLT;
	use XML::LibXML;
	
	my $parser = XML::LibXML->new();
	my $xslt = XML::LibXSLT->new();
	
	#let the xslt param choose other stylesheets or default to xhtml.xsl
	my $param_xslt = $query->param('xslt');
	$param_xslt =~ s/[^\w]//gi;
	
	if( -f "$root/xsl/$param_xslt.xsl")
	{
		$xsltpath = "$root/xsl/$param_xslt.xsl"
	}
	else
	{
		$xsltpath = "$root/xsl/xhtml.xsl";
	}

	my $stylesheet = $xslt->parse_stylesheet($parser->parse_file($xsltpath));

	#TODO: this usage of libxsl omits the xsl:output definition (no ident of html) but outputs in UTF8
	#TODO: later versions of XML::LibXSLT (>= 1.62) define output_as_bytes - this is what we want to use
	#TODO: wait for debian packagers to update to 1.62 or later
	$foo = $stylesheet->transform(
				$parser->parse_string(
					XMLout(
						$page,
						KeyAttr => {},
						RootName => 'page',
						AttrIndent => '1'
					)
				)
			);
	
	#send everything including http headers to the user - if xslt chosen is xspf set download filename
	return $session->header(
			-type=>'text/xml',
			-charset=>'UTF-8'
		),
		$foo->toString;
}
