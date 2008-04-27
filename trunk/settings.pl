require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

my @userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

if($userinfo->{'username'})
{
    if($query->param('submit'))
    {
        $dbh->do(qq{update users set pagesize = ? where id = ?}, undef, $query->param('pagesize'), $userinfo->{'id'} ) or die $dbh->errstr;
        
        @userinfo = get_userinfo_from_sid($session->id);
        
        $page = get_page_array(@userinfo);
        
        $page->appendChild(message("information", "information_settings_changed"));
    }
}

    
if($userinfo->{'username'})
{
    my $settings = XML::LibXML::Element->new( "settings" );
    $settings->setAttribute("pagesize", $userinfo->{'pagesize'});
    $page->appendChild($settings);
}
else
{
    $page->appendChild(message("error", "error_202c"));
}

$doc->setDocumentElement($page);

output_page($doc);
