require "functions.pl";

#create or resume session
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

$page->{frontpage} = [''];

if($query->param('information'))
{
    $page->{'message'}->{'type'} = "information";
    $page->{'message'}->{'text'} = $query->param('information');
    $page->{'message'}->{'value'} = $query->param('value');
}
elsif($query->param('error'))
{
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = $query->param('error');
    $page->{'message'}->{'value'} = $query->param('value');
}
elsif($query->param('warning'))
{
    $page->{'message'}->{'type'} = "warning";
    $page->{'message'}->{'text'} = $query->param('warning');
    $page->{'message'}->{'value'} = $query->param('value');
}


#prepare query
my $sth = $dbh->prepare(qq{select text, count from tagcloud }) or die $dbh->errstr;

#execute it
$sth->execute() or die $dbh->errstr;

#get every returned value
while (my ($text, $count) = $sth->fetchrow_array())
{
    #push the new value to the $page->tagcloud array
    push @{ $page->{tagcloud}->{tag} }, { text => [$text =~ / / ? "\"$text\"" : $text], count => [$count] };
}

#finish query
$sth->finish() or die $dbh->errstr;

#TODO: make this configureable
@querystrings = ("* orderby:timestamp sort:descending", "*", "*");

foreach $strquery (@querystrings)
{
    #new results block
    push @{$page->{'results'} }, { "query" => $strquery };
    
    #get query string and args
    my ($dbquery, @args) = get_sqlquery($strquery);
    $dbquery .= " limit 0, 3";
    
    #prepare query
    $sth = $dbh->prepare($dbquery) or die $dbh->errstr;

    #execute it
    $sth->execute(@args) or die $dbquery;
    
    #foreach result, fill appropriate results hash
    while (my ($id, $title, $description, $publisher, $timestamp, $creator,
            $subject, $source, $language, $coverage, $rights,
            $license, $filesize, $duration, $width, $height, $fps, $viewcount,
            $downloadcount) = $sth->fetchrow_array())
    {
        push @{$page->{'results'}[$#{$page->{'results'} }]->{'result'}},
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
}

print output_page();
