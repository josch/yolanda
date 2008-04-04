require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

#check if query is set
if($query->param('query'))
{
    $page->{'results'}->{'query'} = $query->param('query');
    
    my @args = ();
    
    $strquery = $query->param('query');
    $strquery =~ s/%([0-9A-F]{2})/chr(hex($1))/eg;
    (@tags) = $strquery =~ /tag:(\w+)/gi;
    ($orderby) = $strquery =~ /orderby:(\w+)/i;
    ($sort) = $strquery =~ /sort:(\w+)/i;
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
    $strquery =~ s/(tag|orderby|sort):\w+//gi;
    $strquery =~ s/^\s*(.*?)\s*$/$1/;

    #build mysql query
    $dbquery = "select v.id, v.title, v.description, u.username,
        from_unixtime( v.timestamp ), v.creator, v.subject, 
        v.source, v.language, v.coverage, v.rights, v.license, filesize,
        duration, width, height, fps, viewcount, downloadcount";
    
    if($strquery)
    {
        $dbquery .= ", match(v.title, v.description, v.subject) against( ? in boolean mode) as relevance";
        $dbquery .= " from videos as v, users as u where u.id = v.userid";
        $dbquery .= " and match(v.title, v.description, v.subject) against( ? in boolean mode)";
        push @args, $strquery, $strquery;
    }
    else
    {
        $dbquery .= " from videos as v, users as u where u.id = v.userid";
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
    
    fill_results(@args);
    
    if(@{$page->{'results'}->{'result'}} == 0)
    {
        print $query->redirect("index.pl?warning=warning_no_results");
    }
    elsif((@{$page->{'results'}->{'result'}} == 1) and (not $query->param('page') or $query->param('page') == 1))
    {
        print $query->redirect($page->{'results'}->{'result'}[0]->{'rdf:RDF'}->{'cc:Work'}->{'dc:identifier'}[0]);
    }
    else
    {
        print output_page();
    }
}
elsif($query->param('advanced'))
{
    print $query->redirect("index.pl?error=error_202c");
}
else
{
    print $query->redirect("index.pl?error=error_no_query");
}
