require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

#check if query is set
if($query->param('query'))
{
    $page->{'results'}->{'query'} = $query->param('query');
    
    my ($dbquery, @args) = get_sqlquery($query->param('query'));
    
    if($dbquery)
    {
        fill_results($dbquery, @args);
        
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
    else
    {
        print $query->redirect("index.pl?error=error_no_query");
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
