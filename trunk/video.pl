require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

#check if id or title is passed
if($query->url_param('id'))
{
    $dbquery = "select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ),
                        v.creator, v.subject, v.source, v.language, v.coverage, v.rights,
                        v.license, filesize, duration, width, height, fps, viewcount, downloadcount
                        from videos as v, users as u where v.id = ? and u.id=v.userid";
                        
    @args = ($query->url_param('id'));
    
    $sth = $dbh->prepare($dbquery);
    $rowcount = $sth->execute(@args) or die $dbh->errstr;
    
    #if there are still no results
    if($rowcount == 0)
    {
        #check if maybe the video has not yet been converted
        $dbquery = "select id from uploaded where id = ?";
        $sth = $dbh->prepare($dbquery);
        $rowcount = $sth->execute($query->url_param('id')) or die $dbh->errstr;
        
        #if id is found
        if($rowcount == 1)
        {
            $sth = $dbh->prepare("select sum(duration) from uploaded where id < ?");
            $sth->execute($query->url_param('id')) or die $dbh->errstr;
            ($length) = $sth->fetchrow_array();
            $h = int($length/3600);
            $m = int($length/60-$h*60);
            $s = int($length-$m*60-$h*3600);
            print $query->redirect("/index.pl?information=information_video_not_yet_available&value=".$h."h ".$m."m ".$s."s");
        }
        else
        {
            # there is nothing we can do now - this video doesn't exist...    
            print $query->redirect("/index.pl?error=error_no_video");
            # this is a typical 404 situation, why is there no 404 ?
        }
    }
    elsif($rowcount == 1)
    {
        if($query->param('embed') eq "video")
        {
            $page->setAttribute( "embed", "video" );
        }
        elsif($query->param('embed') eq "preview")
        {
            $page->setAttribute( "embed", "preview" );
        }
    
        #if there was a single result, display the video
        my ($id, $title, $description, $publisher, $timestamp, $creator, $subject,
            $source, $language, $coverage, $rights, $license,
            $filesize, $duration, $width, $height, $fps, $viewcount, $downloadcount) = $sth->fetchrow_array();
        
        #finish query
        $sth->finish() or die $dbh->errstr;
        
        #if user is logged in
        if($userinfo->{'username'})
        {
            #check if a comment is about to be created
            if($query->param('comment'))
            {
                my $dtd = XML::LibXML::Dtd->new(0, "$root/site/comment.dtd");
                $dom = XML::LibXML->new;
                $dom->clean_namespaces(1);
                eval { $doc = $dom->parse_string("<comment>".$query->param('comment')."</comment>") };
                if ($@)
                {
                    die $@;
                }
                else
                {
                    eval { $doc->validate($dtd) };
                    if ($@)
                    {
                        die $@;
                    }
                    else
                    {
                        #output infobox
                        $page->appendChild(message("information", "information_comment_created"));
                        
                        #add to database
                        $dbh->do(qq{insert into comments (userid, videoid, text, timestamp) values (?, ?, ?, unix_timestamp())}, undef,
                                $userinfo->{'id'}, $id, $query->param('comment')) or die $dbh->errstr;
                        
                        #send pingbacks to every url in the comment
                        my (@matches) = $query->param('comment') =~ /<a[^>]+href="(http:\/\/\S+)"[^>]*>.+?<\/a>/gi;
                        foreach $match (@matches)
                        {
                            #ask for http header only - if pingbacks are implemented right, then we wont need the full site
                            my $request = HTTP::Request->new(HEAD => $match);
                            my $ua = LWP::UserAgent->new;
                            
                            my $response = $ua->request($request);
                            
                            if ($response->is_success)
                            {
                                my $pingbackurl = $response->header("x-pingback");
                                
                                #if there was no x-pingback header, fetch the website and search for link element
                                if (!$pingbackurl)
                                {
                                    $request = HTTP::Request->new(GET => $match);
                                    $response = $ua->request($request);
                                    
                                    if ($response->is_success)
                                    {
                                        ($pingbackurl) = $response->content =~ /<link rel="pingback" href="([^"]+)" ?\/?>/;
                                    }
                                }
                                
                                #if requests were successful, send the pingbacks
                                if ($pingbackurl)
                                {
                                    #TODO: expand xml entities &lt; &gt; &amp; &quot; in $pingbackurl
                                    
                                    #contruct the xml-rpc request
                                    my $xmlpost = ();
                                    $xmlpost->{"methodName"} = ["pingback.ping"];
                                    push @{$xmlpost->{'params'}->{'param'} },
                                    {
                                        "value" =>
                                        {
                                            "string" => [$config->{"url_root"}."/video/".urlencode($title)."/$id/"]
                                        }
                                    };
                                    push @{$xmlpost->{'params'}->{'param'} },
                                    {
                                        "value" =>
                                        {
                                            "string" => [$match]
                                        }
                                    };
                                    
                                    #post a xml-rpc request
                                    $request = HTTP::Request->new(POST => $pingbackurl);
                                    $request->header('Content-Type' => "application/xml");
                                    $request->content(XMLout(
                                                            $xmlpost,
                                                            XMLDecl => 1,
                                                            KeyAttr => {},
                                                            RootName => 'methodCall'
                                                        ));
                                    $ua = LWP::UserAgent->new;
                                    $response = $ua->request($request);
                                    #TODO: maybe do something on success?
                                }
                            }
                        }
                    }
                }
            }
        }
        
        my $video = XML::LibXML::Element->new( "video" );
        $video->setAttribute('thumbnail', $config->{"url_root"}."/video-stills/thumbnails/$id");
        $video->setAttribute('preview', $config->{"url_root"}."/video-stills/previews/$id");
        $video->setAttribute('filesize', $filesize);
        $video->setAttribute('duration', $duration);
        $video->setAttribute('width', $width);
        $video->setAttribute('height', $height);
        $video->setAttribute('fps', $fps);
        $video->setAttribute('viewcount', $viewcount);
        $video->setAttribute('downloadcount', $downloadcount);
            
        my $rdf = XML::LibXML::Element->new( "RDF" );
        $rdf->setNamespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf");
        
        my $work = XML::LibXML::Element->new( "Work" );
        $work->setNamespace( "http://web.resource.org/cc/", "cc");
        $work->setNamespace( "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf", 0);
        $work->setAttributeNS( "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "about", $config->{"url_root"}."/download/$id/" );
        
        $node = XML::LibXML::Element->new( "coverage" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($coverage);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "creator" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($creator);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "date" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($date);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "description" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($description);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "identifier" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($config->{"url_root"}."/video/".urlencode($title)."/$id/");
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "language" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($language);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "publisher" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($publisher);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "rights" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($rights);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "source" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($source);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "subject" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($subjcet);
        $work->appendChild($node);
        
        $node = XML::LibXML::Element->new( "title" );
        $node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
        $node->appendText($title);
        $work->appendChild($node);
        
        my $license = XML::LibXML::Element->new( "License" );
        $license->setNamespace("http://web.resource.org/cc/", "cc");
        $license->setNamespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf", 0);
        $license->setAttributeNS( "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "about", "http://creativecommons.org/licenses/GPL/2.0/" );
        
        $rdf->appendChild($work);
        $rdf->appendChild($license);
        
        $video->appendChild($rdf);
        
        $page->appendChild($video);
        
        #get comments
        my $comments = XML::LibXML::Element->new( "comments" );
        
        $sth = $dbh->prepare(qq{select comments.id, comments.text, users.username, from_unixtime( comments.timestamp )
                                from comments, users where
                                comments.videoid=? and users.id=comments.userid}) or die $dbh->errstr;
        $sth->execute($id) or die $dbh->errstr;
        while (my ($commentid, $text, $username, $timestamp) = $sth->fetchrow_array())
        {
            my $dom = XML::LibXML->new;
            my $doc = $dom->parse_string("<comment>".$text."</comment>");
            my $comment = $doc->documentElement();
            foreach $node ($comment->getElementsByTagName("*"))
            {
                $node->setNamespace("http://www.w3.org/1999/xhtml", "xhtml");
            }
            $comment->setAttribute('username', $username);
            $comment->setAttribute('timestamp', $timestamp);
            $comment->setAttribute('id', $commentid);
            $comments->appendChild($comment);
        }
        
        $page->appendChild($comments);
        
        $doc->setDocumentElement($page);

        output_page($doc);
    }
}
else
{
    print $query->redirect("index.pl?error=error_202c");
}
