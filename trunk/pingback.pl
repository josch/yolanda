require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

if ($query->param("POSTDATA"))
{
    my $xmlpost = XMLin($query->param("POSTDATA"), ForceArray => 0, KeyAttr => 0);
    
    if (!$@)
    {
        my $method = $xmlpost->{"methodName"};
        my $source = $xmlpost->{"params"}->{"param"}[0]->{"value"}->{"string"};
        my $target = $xmlpost->{"params"}->{"param"}[1]->{"value"}->{"string"};
        
        if ($method eq "pingback.ping")
        {
            if ($source =~ /^http:\/\// and $target =~ /^http:\/\//)
            {
                #fetch the source URI to verify that the source does indeed link to the target.
                my $request = HTTP::Request->new(GET => $source);
                my $ua = LWP::UserAgent->new;
                my $response = $ua->request($request);
                
                if ($response->is_success)
                {
                    #TODO: sanitize regex to grep site content
                    if (my ($text) = $response->content =~ m/(\S*.{0,17}$target.{0,17}\S*)/)
                    {
                        #check data to ensure that the target exists and is a valid entry.
                        my ($vid) = $target =~ /^$config->{'url_root'}\/video\/.*\/(\d+)\/.*/;
                        
                        my $sth = $dbh->prepare("select id from videos where id = ? limit 1");
                        my $rowcount = $sth->execute($vid) or die $dbh->errstr;
                        
                        $sth->finish() or die $dbh->errstr;
                        
                        if ($rowcount)
                        {
                            #check that the pingback has not already been registered.
                            $sth = $dbh->prepare("select id from pingbacks where videoid = ? limit 1");
                            $rowcount = $sth->execute($vid) or die $dbh->errstr;
                            $sth->finish() or die $dbh->errstr;
                            
                            if ($rowcount eq "0E0")
                            {
                                #record the pingback.
                                $dbh->do(qq{insert into pingbacks (source, videoid, text, timestamp) values (?, ?, ?, unix_timestamp())}, undef,
                                        $source, $vid, $text) or die $dbh->errstr;
                                
                                my $xml = ();
                                $xml->{'params'}->{'param'}->{'value'}->{'string'} = ["Pingback from $source to $target registered. Keep the web talking! :-)"];
                                
                                print $session->header(
                                            -type=>'application/xml',
                                            -charset=>'UTF-8',
                                        );

                                print XMLout(
                                        $xml,
                                        XMLDecl => 1,
                                        KeyAttr => {},
                                        RootName => 'methodResponse'
                                    );
                            }
                            else
                            {
                                send_error(48, "The pingback has already been registered.");
                            }
                        }
                        else
                        {
                            send_error(33, "The specified target URI cannot be used as a target.");
                        }
                    }
                    else
                    {
                        send_error(17, "The source URI does not contain a link to the target URI, and so cannot be used as a source.");
                    }
                }
                else
                {
                    send_error(16, "The source URI does not exist.");
                }
            }
            else
            {
                send_error(-32602, "server error. invalid method parameters");
            }
        }
        else
        {
            send_error(-32601, "server error. requested method not found");
        }
    }
    else
    {
        send_error(-32700,"parse error. not well formed");
    }
}
else
{
    print $session->header;
    print "XML-RPC server only accepts POST requests with http content-type defined.";
}

sub send_error
{
    my ($faultCode, $faultString) = @_;

    my $xml = ();
    push @{$xml->{'fault'}->{'value'}->{'struct'}->{'member'}},
    {
        "name" => ["faultCode"],
        "value" => [$faultCode]
    };
    push @{$xml->{'fault'}->{'value'}->{'struct'}->{'member'}},
    {
        "name" => ["faultString"],
        "value" => [$faultString]
    };
    
    print $session->header(
                -type=>'application/xml',
                -charset=>'UTF-8',
            );

    print XMLout(
            $xml,
            XMLDecl => 1,
            KeyAttr => {},
            RootName => 'methodResponse'
        );
}

