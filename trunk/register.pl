require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $root = get_page_array(@userinfo);

#check if user is logged in
if($username)
{
    my $message = XML::LibXML::Element->new( "message" );
    $message->setAttribute("type", "error");
    $message->setAttribute("text", "error_already_registered");
    $root->appendChild($message);
    
    $doc->setDocumentElement($root);

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
            $root->appendChild(XML::LibXML::Element->new( "registerform" ));
            
            my $message = XML::LibXML::Element->new( "message" );
            $message->setAttribute("type", "error");
            $message->setAttribute("text", "error_username_already_registered");
            $root->appendChild($message);
            
            $doc->setDocumentElement($root);

            output_page($doc);
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
        $root->appendChild(XML::LibXML::Element->new( "registerform" ));
        
        my $message = XML::LibXML::Element->new( "message" );
        $message->setAttribute("type", "error");
        $message->setAttribute("text", "error_passwords_do_not_match");
        $root->appendChild($message);
        
        $doc->setDocumentElement($root);

        output_page($doc);
    }
}
elsif(not $query->param('user') and ($query->param('pass') or $query->param('pass_repeat')))
{
    $root->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    my $message = XML::LibXML::Element->new( "message" );
    $message->setAttribute("type", "error");
    $message->setAttribute("text", "error_insert_username");
    $root->appendChild($message);
    
    $doc->setDocumentElement($root);

    output_page($doc);
}
elsif(not $query->param('pass') and ($query->param('user') or $query->param('pass_repeat')))
{
    $root->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    my $message = XML::LibXML::Element->new( "message" );
    $message->setAttribute("type", "error");
    $message->setAttribute("text", "error_insert_password");
    $root->appendChild($message);
    
    $doc->setDocumentElement($root);

    output_page($doc);
}
elsif(not $query->param('pass_repeat') and ($query->param('user') or $query->param('pass')))
{
    $root->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    my $message = XML::LibXML::Element->new( "message" );
    $message->setAttribute("type", "error");
    $message->setAttribute("text", "error_repeat_password");
    $root->appendChild($message);
    
    $doc->setDocumentElement($root);

    output_page($doc);
}
else
{
    $root->appendChild(XML::LibXML::Element->new( "registerform" ));
    
    $doc->setDocumentElement($root);

    output_page($doc);
}
