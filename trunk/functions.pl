require "include.pl";

sub get_userinfo_from_sid
{
    #get parameters
    my ($sid) = @_;
    
    #prepare query
    my $sth = $dbh->prepare(qq{select id, username, pagesize from users where sid = ?}) or die $dbh->errstr;
    
    #execute it
    $sth->execute($sid) or die $dbh->errstr;
    
    #save the resulting username
    ($userinfo->{'id'}, $userinfo->{'username'}, $userinfo->{'pagesize'}) = $sth->fetchrow_array();
    
    #finish query
    $sth->finish() or die $dbh->errstr;
    
    #return 
    return @userinfo;
}

sub get_page_array
{
    #get parameters
    my (@userinfo) = @_;

    my $root = XML::LibXML::Element->new( "page" );
    
    my ($locale) = $query->http('HTTP_ACCEPT_LANGUAGE') =~ /^([^,]+),.*$/;
    $root->setAttribute( "locale", $locale ? $locale : "en_us" );
    
    $root->setAttribute( "username", $userinfo->{'username'} );
    $root->setNamespace("http://www.w3.org/1999/xhtml", "xhtml", 0);
    $root->setNamespace("http://web.resource.org/cc/", "cc", 0);
    $root->setNamespace("http://purl.org/dc/elements/1.1/", "dc", 0);
    $root->setNamespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf", 0);
    
    return $root;
}

# index.pl (display custom search)
# search.pl (display search results)
# and upload.pl (display similar videos)
sub fill_results
{
    my ($dbquery, @args) = @_;
    
    my $results = XML::LibXML::Element->new( "results" );
    
    #prepare query
    my $sth = $dbh->prepare($dbquery) or die $dbh->errstr;
    
    #execute it
    $resultcount = $sth->execute(@args) or die $dbh->errstr;
    
    #set pagesize by query or usersettings or default
    $pagesize = $query->param('pagesize') or $pagesize =  $userinfo->{'pagesize'} or $pagesize = $config->{"search_results_default"};
    
    #if pagesize is more than maxpagesize reduce to maxpagesize
    $pagesize = $pagesize > $config->{"search_results_max"} ? $config->{"search_results_max"} : $pagesize;
    
    #rediculous but funny round up, will fail with 100000000000000 results per page
    #on 0.0000000000001% of all queries - this is a risk we can handle
    $lastpage = int($resultcount/$pagesize+0.99999999999999);
    
    $currentpage = $query->param('page') or $currentpage = 1;
    
    $dbquery .= " limit ".($currentpage-1)*$pagesize.", ".$pagesize;
    
    #prepare query
    $sth = $dbh->prepare($dbquery) or die $dbh->errstr;
    
    #execute it
    $sth->execute(@args) or die $dbh->errstr;
    
    $results->setAttribute('lastpage', $lastpage);
    $results->setAttribute('currentpage', $currentpage);
    $results->setAttribute('resultcount', $resultcount eq '0E0' ? 0 : $resultcount);
    $results->setAttribute('pagesize', $pagesize);
    
    #get every returned value
    while (my ($id, $title, $description, $publisher, $timestamp, $creator,
        $subject, $source, $language, $coverage, $rights,
        $license, $filesize, $duration, $width, $height, $fps, $viewcount,
        $downloadcount) = $sth->fetchrow_array())
    {
        my $result = XML::LibXML::Element->new( "result" );
        $result->setAttribute( "thumbnail", $config->{"url_root"}."/video-stills/thumbnails/$id" );
        $result->setAttribute( "preview", $config->{"url_root"}."/video-stills/previews/$id" );
        $result->setAttribute( "duration", $duration );
        $result->setAttribute( "viewcount", $viewcount );
        
        my $rdf = XML::LibXML::Element->new( "RDF" );
        $rdf->setNamespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf");
        
        my $work = XML::LibXML::Element->new( "Work" );
        $work->setNamespace( "http://web.resource.org/cc/", "cc");
        $work->setNamespace( "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf", 0);
        $work->setAttributeNS( "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "about", $config->{"url_root"}."/download/$id/" );
        
        $node = XML::LibXML::Element->new( "coverage" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($coverage);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "creator" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($creator);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "date" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($date);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "description" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($description);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "identifier" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($config->{"url_root"}."/video/".urlencode($title)."/$id/");
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "language" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($language);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "publisher" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($publisher);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "rights" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($rights);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "source" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($source);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "subject" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($subjcet);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "title" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($title);
        $work->appendChild($node);
        
        my $license = XML::LibXML::Element->new( "License" );
        $license->setNamespace("http://web.resource.org/cc/", "cc");
        $license->setNamespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf", 0);
        $license->setAttributeNS( "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "about", "http://creativecommons.org/licenses/GPL/2.0/" );
        
        $rdf->appendChild($work);
        $rdf->appendChild($license);
        
        $result->appendChild($rdf);
        
        $results->appendChild($result);
    }
    
    #finish query
    $sth->finish() or die $dbh->errstr;
    
    return $results;
}

sub get_sqlquery
{
    my $strquery = @_[0];
    $strquery =~ s/%([0-9A-F]{2})/chr(hex($1))/eg;
    (@tags) = $strquery =~ / tag:(\w+)/gi;
    ($order) = $strquery =~ / order:(\w+)/i;
    ($sort) = $strquery =~ / sort:(\w+)/i;
    #($title) = $strquery =~ /title:(\w+)/i;
    #($description) = $strquery =~ /description:(\w+)/i;
    #($creator) = $strquery =~ /creator:(\w+)/i;
    #($language) = $strquery =~ /language:(\w+)/i;
    #($coverage) = $strquery =~ /coverage:(\w+)/i;
    #($rights) = $strquery =~ /rights:(\w+)/i;
    #($license) = $strquery =~ /license:(\w+)/i;
    #($filesize) = $strquery =~ /filesize:([<>]?\w+)/i;
    #($duration) = $strquery =~ /duration:([<>]?\w+)/i;
    #($timestamp) = $strquery =~ /timestamp:([<>]?\w+)/i;
    $strquery =~ s/ (tag|order|sort):\w+//gi;
    $strquery =~ s/^\s*(.*?)\s*$/$1/;

    #build mysql query
    my $dbquery = "select v.id, v.title, v.description, u.username,
        from_unixtime( v.timestamp ), v.creator, v.subject, 
        v.source, v.language, v.coverage, v.rights, v.license, filesize,
        duration, width, height, fps, viewcount, downloadcount";

    if($strquery)
    {
        if($strquery eq "*")
        {
            $dbquery .= " from videos as v, users as u where u.id = v.userid";
        }
        else
        {
            $dbquery .= ", match(v.title, v.description, v.subject) against( ? in boolean mode) as relevance";
            $dbquery .= " from videos as v, users as u where u.id = v.userid";
            $dbquery .= " and match(v.title, v.description, v.subject) against( ? in boolean mode)";
            push @args, $strquery, $strquery;
        }
        
        if(@tags)
        {
            $dbquery .= " and match(v.subject) against (? in boolean mode)";
            push @args, "@tags";
        }
        
        if($publisher)
        {
            $dbquery .= " and match(u.username) against (? in boolean mode)";
            push @args, "$publisher";
        }
        
        if($order)
        {
            if($order eq 'filesize')
            {
                $dbquery .= " order by v.filesize";
            }
            elsif($order eq 'duration')
            {
                $dbquery .= " order by v.duration";
            }
            elsif($order eq 'viewcount')
            {
                $dbquery .= " order by v.viewcount";
            }
            elsif($order eq 'downloadcount')
            {
                $dbquery .= " order by v.downloadcount";
            }
            elsif($order eq 'timestamp')
            {
                $dbquery .= " order by v.timestamp";
            }
            elsif($order eq 'relevance')
            {
                $dbquery .= " order by relevance";
            }
            else
            {
                $dbquery .= " order by $config->{'search_order_default'}";
            }
            
            if($sort eq "ascending")
            {
                $dbquery .= " asc";
            }
            elsif($sort eq "descending")
            {
                $dbquery .= " desc";
            }
            else
            {
                $dbquery .= " $config->{'search_sort_default'}";
            }
        }
        
        return $dbquery, @args;
    }
}

#replace chars in url according to RFC 1738 <http://www.rfc-editor.org/rfc/rfc1738.txt>
sub urlencode
{
    my ($url) = @_[0];
    $url =~ s/([^A-Za-z0-9_\$\-.+!*'()])/sprintf("%%%02X", ord($1))/eg;
    return $url;
}

sub output_page
{
    my $doc = shift;
    my $parser = XML::LibXML->new();
    my $xslt = XML::LibXSLT->new();

    # let the XSLT param choose other stylesheets or default to xhtml.xsl
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
    
    #TODO: preload xslt stylesheet
    my $stylesheet = $xslt->parse_stylesheet($parser->parse_file($xsltpath));

    $output = $stylesheet->transform($doc);
    
    if($param_xslt eq "xspf")
    {
        return $session->header(
            -type=>$stylesheet->media_type,
            -charset=>$stylesheet->output_encoding,
            -attachment=>$query->param('query').".xspf",
        ),
        $output->toString;
        #$stylesheet->output_as_bytes($output); <= for future use with XML::LibXSLT (>= 1.62)
    }
    elsif($param_xslt eq "pr0n")
    {
        return $session->header(
            -status=>'402 Payment required',
            -cost=>'$9001.00',  # OVER NEIN THOUSAND
        )
    }
    else
    {
        return $session->header(
            -type=>$stylesheet->media_type,
            -charset=>$stylesheet->output_encoding,
            "x-pingback"=>$config->{"url_root"}."/pingback.pl"
        ),
        print $output->toString;
        #$stylesheet->output_as_bytes($output); <= for future use with XML::LibXSLT (>= 1.62)
    }
}
