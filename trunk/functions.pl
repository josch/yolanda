require "include.pl";

sub get_userinfo_from_sid
{
    #get parameters
    my ($sid) = @_;
    
    #prepare query
    my $sth = $dbh->prepare(qq{select id, username, locale, pagesize from users where sid = ?}) or die $dbh->errstr;
    
    #execute it
    $sth->execute($sid) or die $dbh->errstr;
    
    #save the resulting username
    ($userinfo->{'id'}, $userinfo->{'username'}, $userinfo->{'locale'}, $userinfo->{'pagesize'}) = $sth->fetchrow_array();
    
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
        unless($page->{'locale'})
        {
            $page->{'locale'} = "en_us";
        }
    }
    
    $page->{'username'} = $userinfo->{'username'};
    $page->{'xmlns:dc'} = $config->{"xml_namespace_dc"};
    $page->{'xmlns:cc'} = $config->{"xml_namespace_cc"};
    $page->{'xmlns:rdf'} = $config->{"xml_namespace_rdf"};

}

# index.pl (display custom search)
# search.pl (display search results)
# and upload.pl (display similar videos)
sub fill_results
{
    my ($dbquery, @args) = @_;

    #prepare query
    my $sth = $dbh->prepare($dbquery) or die $dbh->errstr;
    
    #execute it
    $resultcount = $sth->execute(@args) or die $dbh->errstr;
    
    #set pagesize by query or usersettings or default
    $pagesize = $query->param('pagesize') or $pagesize =  $userinfo->{'pagesize'} or $pagesize = $config->{"page_results_pagesize_default"};
    
    #if pagesize is more than maxpagesize reduce to maxpagesize
    $pagesize = $pagesize > $config->{"page_results_pagesize_max"} ? $config->{"page_results_pagesize_max"} : $pagesize;
    
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
    $page->{'results'}->{'resultcount'} = $resultcount eq '0E0' ? 0 : $resultcount;
    $page->{'results'}->{'pagesize'} = $pagesize;
    
    #get every returned value
    while (my ($id, $title, $description, $publisher, $timestamp, $creator,
        $subject, $source, $language, $coverage, $rights,
        $license, $filesize, $duration, $width, $height, $fps, $viewcount,
        $downloadcount) = $sth->fetchrow_array())
    {
        #before code cleanup, this was a really obfuscated array/hash creation
        push @{ $page->{'results'}->{'result'} },
        {
            'thumbnail' => $config->{"url_root"}."/video-stills/thumbnails/$id",
            'preview'   => $config->{"url_root"}."/video-stills/previews/$id",
            'duration'  => $duration,
            'viewcount' => $viewcount,
            'rdf:RDF'   =>
            {
                'cc:Work'   =>
                {
                    'rdf:about'         => $config->{"url_root"}."/download/$id/",
                    'dc:title'          => [$title],
                    'dc:creator'        => [$creator],
                    'dc:subject'        => [$subject],
                    'dc:description'    => [$description],
                    'dc:publisher'      => [$publisher],
                    'dc:date'           => [$timestamp],
                    'dc:identifier'     => [$config->{"url_root"}."/video/".urlencode($title)."/$id/"],
                    'dc:source'         => [$source],
                    'dc:language'       => [$language],
                    'dc:coverage'       => [$coverage],
                    'dc:rights'         => [$rights]
                },
                'cc:License'    =>
                {
                    'rdf:about'     => 'http://creativecommons.org/licenses/GPL/2.0/'
                }
            }
        };
    }
    
    #finish query
    $sth->finish() or die $dbh->errstr;
}

sub get_sqlquery
{
    my $strquery = @_[0];
    $strquery =~ s/%([0-9A-F]{2})/chr(hex($1))/eg;
    (@tags) = $strquery =~ / tag:(\w+)/gi;
    ($orderby) = $strquery =~ / orderby:(\w+)/i;
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
    $strquery =~ s/ (tag|orderby|sort):\w+//gi;
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
        
        if($orderby)
        {
            if($orderby eq 'filesize')
            {
                $dbquery .= " order by v.filesize";
            }
            elsif($orderby eq 'duration')
            {
                $dbquery .= " order by v.duration";
            }
            elsif($orderby eq 'viewcount')
            {
                $dbquery .= " order by v.viewcount";
            }
            elsif($orderby eq 'downloadcount')
            {
                $dbquery .= " order by v.downloadcount";
            }
            elsif($orderby eq 'timestamp')
            {
                $dbquery .= " order by v.timestamp";
            }
            elsif($orderby eq 'relevance' and $strquery)
            {
                $dbquery .= " order by relevance";
            }
            else
            {
                $dbquery .= " order by v.id";
            }
            
            if($sort eq "ascending")
            {
                $dbquery .= " asc";
            }
            elsif($sort eq "descending")
            {
                $dbquery .= " desc";
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
    my $parser = XML::LibXML->new();
    my $xslt = XML::LibXSLT->new();

    # let the XSLT param choose other stylesheets or default to xhtml.xsl
    my $param_xslt = $query->param('xslt');
    $param_xslt =~ s/[^\w]//gi;

    # "null" is a debuggin option, make it so that this doesn't show up in the final product
    if($param_xslt eq "null")
    {
        return $session->header(
            -type=>'application/xml',
            -charset=>'UTF-8',
        ),
        XMLout(
                $page,
                KeyAttr => {},
                RootName => 'page'
        );
    }
    else
    {
        if( -f "$root/xsl/$param_xslt.xsl")
        {
            $xsltpath = "$root/xsl/$param_xslt.xsl"
        }
        else
        {
            $xsltpath = "$root/xsl/xhtml.xsl";
        }
        
        my $stylesheet = $xslt->parse_stylesheet($parser->parse_file($xsltpath));

        $output = $stylesheet->transform(
                $parser->parse_string(
                    XMLout(
                        $page,
                        KeyAttr => {},
                        RootName => 'page'
                    )
                )
            );
        
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
            $output->toString;
            #$stylesheet->output_as_bytes($output); <= for future use with XML::LibXSLT (>= 1.62)
        }
    }
}
