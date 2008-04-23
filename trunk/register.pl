require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

#check if user is logged in
if($username)
{
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_already_registered";
    
    print output_page();
}
#if username and password are passed put them into the database
elsif($query->param('user') and $query->param('pass') and $query->param('pass_repeat'))
{
    if($query->param('pass') eq $query->param('pass_repeat'))
    {
        my $sth = $dbh->prepare(qq{select id from users where username = ? limit 1 });
                
        #execute query
        $sth->execute($query->param('user'));
        
        #if something was returned the selected username already exists
        if($sth->fetchrow_array())
        {
            $page->{'registerform'} = [''];
            $page->{'message'}->{'type'} = "error";
            $page->{'message'}->{'text'} = "error_username_already_registered";
    
            print output_page();
        }
        else
        {
            #insert new user
            $dbh->do(qq{insert into users (username, password, timestamp) values ( ?, password( ? ), unix_timestamp(), ?)}, undef,
                    $query->param("user"), $query->param("pass")) or die $dbh->errstr;
        
            print $query->redirect("index.pl?information=information_registered");
        }
    }
    else
    {
        $page->{'registerform'} = [''];
        $page->{'message'}->{'type'} = "error";
        $page->{'message'}->{'text'} = "error_passwords_do_not_match";
    
        print output_page();
    }
}
elsif(not $query->param('user') and ($query->param('pass') or $query->param('pass_repeat')))
{
    $page->{'registerform'} = [''];
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_insert_username";
    
    print output_page();
}
elsif(not $query->param('pass') and ($query->param('user') or $query->param('pass_repeat')))
{
    $page->{'registerform'} = [''];
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_insert_password";
    
    print output_page();
}
elsif(not $query->param('pass_repeat') and ($query->param('user') or $query->param('pass')))
{
    $page->{'registerform'} = [''];
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_repeat_password";
    
    print output_page();
}
else
{
    $page->{'registerform'} = [''];
    
    print output_page();
}
