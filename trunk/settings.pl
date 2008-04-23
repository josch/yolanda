require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

if($userinfo->{'username'})
{
    if($query->param('submit'))
    {
        $dbh->do(qq{update users set pagesize = ? where id = ?}, undef, $query->param('pagesize'), $userinfo->{'id'} ) or die $dbh->errstr;
        
        $page->{'message'}->{'type'} = "information";
        $page->{'message'}->{'text'} = "information_settings_changed";
    }
}

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);
    
if($userinfo->{'username'})
{
    $page->{'settings'}->{'pagesize'} = $userinfo->{'pagesize'};
}
else
{
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_202c";
}

print output_page();
