require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

my @userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $root = get_page_array(@userinfo);

if($userinfo->{'username'})
{
    if($query->param('submit'))
    {
        $dbh->do(qq{update users set pagesize = ? where id = ?}, undef, $query->param('pagesize'), $userinfo->{'id'} ) or die $dbh->errstr;
        
        @userinfo = get_userinfo_from_sid($session->id);
        
        $root = get_page_array(@userinfo);
        
        my $message = XML::LibXML::Element->new( "message" );
        $message->setAttribute("type", "information");
        $message->setAttribute("text", "information_settings_changed");
        $root->appendChild($message);
    }
}

    
if($userinfo->{'username'})
{
    my $settings = XML::LibXML::Element->new( "settings" );
    $settings->setAttribute("pagesize", $userinfo->{'pagesize'});
    $root->appendChild($settings);
}
else
{
    my $message = XML::LibXML::Element->new( "message" );
    $message->setAttribute("type", "error");
    $message->setAttribute("text", "error_202c");
    $root->appendChild($message);
}

$doc->setDocumentElement($root);

output_page($doc);
