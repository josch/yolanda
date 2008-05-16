require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

$page->setNamespace( $config->{"xml_namespace_cc"}, "cc", 0);
$page->setNamespace( $config->{"xml_namespace_dc"}, "dc", 0);
$page->setNamespace( $config->{"xml_namespace_rdf"}, "rdf", 0);

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
        
        $doc->setDocumentElement($page);
        
        #get all found results
        my @results = $doc->findnodes( "//results/result" );
        
        #set result query in result's parent
        $results[0]->parentNode->setAttribute('query', $query->param('query'));
        
        #if result count is zero
        if($#results == -1)
        {
            print $query->redirect("index.pl?warning=warning_no_results");
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
