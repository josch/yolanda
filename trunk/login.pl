require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

if($query->param('action') eq "logout")
{
    #if logout is requested
    #remove sid from database
    $dbh->do(qq{update users set sid = '' where id = ?}, undef, $userinfo->{'id'}) or die $dbh->errstr;
    $session->delete();
    print $query->redirect("index.pl?information=information_logged_out");
}
#check if user is logged in
elsif($userinfo->{'username'})
{
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_already_logged_in";
    
    print output_page();
}
#if password is empty and username begins with http:// then it's an openid login
elsif($query->param('pass') eq '' and $query->param('user')=~m/^http:\/\//)
{
    #create our openid consumer object
    $con = Net::OpenID::Consumer->new(
    ua => LWPx::ParanoidAgent->new, # FIXME - use LWPx::ParanoidAgent
    cache => undef, # or File::Cache->new,
    args => $query,
    consumer_secret => $session->id, #is this save? don't know...
    required_root => $domain );
    
    #is an openid passed?
    if($query->param('user'))
    {
        #claim identity
        $claimed = $con->claimed_identity($query->param('user'));
        if(!defined($claimed))
        {
            print $query->redirect("/index.pl?error=error_openid_".$con->errcode);
        }
        else
        {
            #try to set the check_url
            $check_url = $claimed->check_url(
                    return_to  => "$domain/login.pl?action=openid", #on success return to this address
                    trust_root => $domain); #this is the string the user will be asked to trust
                    
            #redirect to openid server to check claim
            print $query->redirect($check_url);
        }
    }
    else
    {
        #if not, print login form
        $page->{'loginform'} = [''];

        print output_page();
    }
}
#we return from an identity check
elsif($query->param('action') eq 'openid')
{
    #create our openid consumer object
    $con = Net::OpenID::Consumer->new(
    ua => LWPx::ParanoidAgent->new, # FIXME - use LWPx::ParanoidAgent
    cache => undef, # or File::Cache->new,
    args => $query,
    consumer_secret => $session->id, #is this save? don't know...
    required_root => $domain );
    
    if($setup_url = $con->user_setup_url)
    {
        #redirect to setup url - user will give confirmation there
        print $query->redirect($setup_url);
    }
    elsif ($con->user_cancel)
    {
        #cancelled - redirect to login form
        print $query->redirect("index.pl");
    }
    elsif ($vident = $con->verified_identity)
    {
        #we are verified!!
        my $verified_url = $vident->url;
        
        #check if this openid user already is in database
        my $sth = $dbh->prepare(qq{select 1 from users where username = ? limit 1 });
        $sth->execute($verified_url);
        if($sth->fetchrow_array())
        {
            #store session id in database
            $dbh->do(qq{update users set sid = ? where username = ? }, undef, $session->id, $verified_url) or die $dbh->errstr;
        }
        else
        {
            #add openid user to dabase
            $dbh->do(qq{insert into users (username, sid) values ( ?, ? ) }, undef, $verified_url, $session->id) or die $dbh->errstr;
        }
        
        print $query->redirect("index.pl?information=information_logged_in");
    }
    else
    {
        #an error occured
        print $session->header();
        print "error validating identity: ", $con->errcode;
    }
}
#else it's a normal login
elsif($query->param('pass') ne '' and $query->param('user')!~m/^http:\/\// and $query->param('user') ne '')
{
    #prepare query - empty password are openid users so omit those entries
    my $sth = $dbh->prepare(qq{select id from users
            where password = password( ? ) and username = ? limit 1 });
            
    #execute query
    $sth->execute($query->param('pass'), $query->param('user'));
    
    #if something was returned username and password match
    if($sth->fetchrow_array())
    {
        #store session id in database
        $dbh->do(qq{update users set sid = ? where username = ? }, undef, $session->id, $query->param('user')) or die $dbh->errstr;
        print $query->redirect("index.pl?information=information_logged_in");
    }
    else
    {
        #if not, print error
        $page->{'message'}->{'type'} = "error";
        $page->{'message'}->{'text'} = "error_username_password_do_not_match";
        
        print output_page();
    }
}
else
{
    #if not, print login form
    $page->{'loginform'} = [''];
    
    print output_page();
}
