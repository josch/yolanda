require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

#check if user is logged in
if($username)
{
    $page->appendChild(message("error", "error_already_registered"));
    
    $doc->setDocumentElement($page);

    output_page($doc);
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
            $page->appendChild(XML::LibXML::Element->new( "registerform" ));
            
            $page->appendChild(message("error", "error_username_already_registered"));
            
            $doc->setDocumentElement($page);

            output_page($doc);
        }
        else
        {
            #insert new user
            $dbh->do(qq{insert into users (username, password, timestamp, sid) values ( ?, password( ? ), unix_timestamp(), ?)}, undef,
                    $query->param("user"), $query->param("pass"), $session->id) or die $dbh->errstr;
        
            print $query->redirect("index.pl?information=information_registered");
        }
    }
    else
    {
        $page->appendChild(XML::LibXML::Element->new( "registerform" ));
        
        $page->appendChild(message("error", "error_passwords_do_not_match"));
        
        $doc->setDocumentElement($page);

        output_page($doc);
    }
}
elsif(not $query->param('user') and ($query->param('pass') or $query->param('pass_repeat')))
{
    $page->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    $page->appendChild(message("error", "error_insert_username"));
    
    $doc->setDocumentElement($page);

    output_page($doc);
}
elsif(not $query->param('pass') and ($query->param('user') or $query->param('pass_repeat')))
{
    $page->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    $page->appendChild(message("error", "error_insert_password"));
    
    $doc->setDocumentElement($page);

    output_page($doc);
}
elsif(not $query->param('pass_repeat') and ($query->param('user') or $query->param('pass')))
{
    $page->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    $page->appendChild(message("error", "error_repeat_password"));
    
    $doc->setDocumentElement($page);

    output_page($doc);
}
else
{
    $page->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    $doc->setDocumentElement($page);

    output_page($doc);
}
