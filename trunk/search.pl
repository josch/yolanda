require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

#check if query is set
if($query->param('query'))
{
    #construct querystring and arguments from user query
    my ($dbquery, @args) = get_sqlquery($query->param('query'));
    
    #if successful
    if($dbquery)
    {
        #fill xml with search results
        $page->appendChild(fill_results($dbquery, @args));
        $page->setAttribute('query', $query->param('query'));
        
        $doc->setDocumentElement($page);
        
        #get all results
        my @results = $doc->findnodes( "//results/result" );
        
        #if result count is zero
        if($#results == -1)
        {
            print $query->redirect("index.pl?warning=warning_no_results");
        }
        #if there is only one results, redirect to video directly
        elsif(($#results == 0) and (not $query->param('page') or $query->param('page') == 1))
        {
            print $query->redirect(@{$doc->findnodes( "//results/result/rdf:RDF/cc:Work/dc:identifier/text()" )}[0]->data);
        }
        else
        {
            output_page($doc);
        }
    }
    else
    {
        print $query->redirect("index.pl?error=error_no_query");
    }
}
else
{
    print $query->redirect("index.pl?error=error_no_query");
}
