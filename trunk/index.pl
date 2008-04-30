require "functions.pl";

#create or resume session
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

$page->setNamespace( $config->{"xml_namespace_cc"}, "cc", 0);
$page->setNamespace( $config->{"xml_namespace_dc"}, "dc", 0);
$page->setNamespace( $config->{"xml_namespace_rdf"}, "rdf", 0);

#TODO: make the <frontpage> element unneccesary
$page->appendChild(XML::LibXML::Element->new( "frontpage" ));

#if a message box is to be shown
if($query->param('information'))
{
    $page->appendChild(message("information", $query->param('information'), $query->param('value')));
}
elsif($query->param('error'))
{
    $page->appendChild(message("error", $query->param('error'), $query->param('value')));
}
elsif($query->param('warning'))
{
    $page->appendChild(message("warning", $query->param('warning'), $query->param('value')));
}

#new tagcloud xml element
my $tagcloud = XML::LibXML::Element->new( "tagcloud" );

#prepare query
my $sth = $dbh->prepare(qq{select text, count from tagcloud }) or die $dbh->errstr;

#execute it
$sth->execute() or die $dbh->errstr;

#get every returned value and append it to tagcloud
while (my ($text, $count) = $sth->fetchrow_array())
{
    #TODO: why not use <tag count="">text</tag>
    my $tag = XML::LibXML::Element->new( "tag" );
    $tag->appendTextChild("text", $text);
    $tag->appendTextChild("count", $count);
    $tagcloud->appendChild($tag);
}

#finish query
$sth->finish() or die $dbh->errstr;

$page->appendChild($tagcloud);

#now get the frontpage video queries from config and process them
foreach $strquery ($config->{"search_frontpage_one_query"}, $config->{"search_frontpage_two_query"}, $config->{"search_frontpage_three_query"})
{
    #new results block
    my $results = XML::LibXML::Element->new( "results" );
    $results->setAttribute( "query", $strquery );
    
    #get query string and args
    my ($dbquery, @args) = get_sqlquery($strquery);
    $dbquery .= " limit 0, $config->{'search_frontpage_size'}";
    
    #prepare query
    $sth = $dbh->prepare($dbquery) or die $dbh->errstr;

    #execute it
    $sth->execute(@args) or die @args;
    
    #foreach result, fill appropriate results hash
    while (my ($id, $title, $description, $publisher, $timestamp, $creator,
            $subject, $source, $language, $coverage, $rights,
            $license, $filesize, $duration, $width, $height, $fps, $viewcount,
            $downloadcount) = $sth->fetchrow_array())
    {
        #construct xml
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
    $page->appendChild($results);
}

$doc->setDocumentElement($page);

output_page($doc);
