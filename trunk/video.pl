require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

if($query->url_param('action') eq 'edit' and $query->url_param('id'))
{
    $page->{'message'}->{'type'} = "information";
}
if($query->url_param('action') eq 'bookmark' and $query->url_param('id'))
{
    $page->{'message'}->{'type'} = "information";
}
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
            $sth = $dbh->prepare("select sum(duration) from uploaded");
            $sth->execute() or die $dbh->errstr;
            ($length) = $sth->fetchrow_array();
            $h = int($length/3600);
            $m = int($length/60-$h*60);
            $s = int($length-$m*60-$h*3600);
            print $query->redirect("/index.pl?information=information_video_not_yet_available&value=".$h."h ".$m."m ".$s."s");
        }
        else
        {
            #there is nothing we can do now - this video doesn't exist...    
            print $query->redirect("/index.pl?error=error_no_video");
        }
    }
    elsif($rowcount == 1)
    {
        if($query->param('embed') eq "video")
        {
            $page->{'embed'} = "video";
        }
        elsif($query->param('embed') eq "preview")
        {
            $page->{'embed'} = "preview";
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
                #output infobox
                $page->{'message'}->{'type'} = "information";
                $page->{'message'}->{'text'} = "information_comment_created";
            
                #add to database
                $dbh->do(qq{insert into comments (userid, videoid, text, timestamp) values (?, ?, ?, unix_timestamp())}, undef,
                        $userinfo->{'id'}, $id, $query->param('comment')) or die $dbh->errstr;
            }
        }
        
        #if referer is not the local site update referer table
        $referer = $query->referer() or $referer = '';
        if($referer !~ /^$domain/)
        {
            #check if already in database
            $sth = $dbh->prepare(qq{select 1 from referer where videoid = ? and referer = ? }) or die $dbh->errstr;
            my $rowcount = $sth->execute($id, $referer) or die $dbh->errstr;
            $sth->finish() or die $dbh->errstr;
            
            if($rowcount > 0)
            {
                #video is in database - increase referercount
                $dbh->do(qq{update referer set count=count+1 where videoid = ? and referer = ? }, undef, $id, $referer) or die $dbh->errstr;
            }
            else
            {
                #add new referer
                $dbh->do(qq{insert into referer (videoid, referer) values (?, ?) }, undef, $id, $referer) or die $dbh->errstr;
            }
        }
        
        #before code cleanup, this was a really obfuscated array/hash creation
        push @{ $page->{'video'} },
        {
            'thumbnail'     => "$domain/video-stills/thumbnails/$id",
            'preview'       => "$domain/video-stills/previews/$id",
            'filesize'      => $filesize,
            'duration'      => $duration,
            'width'         => $width,
            'height'        => $height,
            'fps'           => $fps,
            'viewcount'     => $viewcount,
            'downloadcount' => $downloadcount,
            'rdf:RDF'       =>
            {
                'cc:Work'       =>
                {
                    'rdf:about'         => "$domain/download/$id/",
                    'dc:title'          => [$title],
                    'dc:creator'        => [$creator],
                    'dc:subject'        => [$subject],
                    'dc:description'    => [$description],
                    'dc:publisher'      => [$publisher],
                    'dc:date'           => [$timestamp],
                    'dc:identifier'     => ["$domain/video/".urlencode($title)."/$id/"],
                    'dc:source'         => [$source],
                    'dc:language'       => [$language],
                    'dc:coverage'       => [$coverage],
                    'dc:rights'         => [$rights]
                },
                'cc:License'    =>
                {
                    'rdf:about'     => $license,
# ↓↓ dummy code because josch is too lazy for DOIN IT RITE ↓↓
                    'cc:permits'    =>
                        {
                            'rdf:resource'     => "http://web.resource.org/cc/Reproduction"
                        },
                    'cc:permits'    =>
                        {
                            'rdf:resource'     => "http://web.resource.org/cc/Distribution"
                        },
                    'cc:permits'    =>
                        {
                            'rdf:resource'     => "http://web.resource.org/cc/DerivativeWorks"
                        },
                    'cc:requires'    =>
                        {
                            'rdf:resource'     => "http://web.resource.org/cc/Notice"
                        },
                    'cc:requires'    =>
                        {
                            'rdf:resource'     => "http://web.resource.org/cc/ShareAlike"
                        },
                    'cc:prohibits'    =>
                        {
                            'rdf:resource'     => "http://web.resource.org/cc/CommercialUse"
                        },
                    'cc:prohibits'    =>
                        {
                            'rdf:resource'     => "http://web.resource.org/cc/DerivativeWorks"
                        }
# ↑↑ dummy code because josch is too lazy for DOIN IT RITE ↑↑
# sadly, i dunno how to add multiple tags 
                }
            }
        };
        
        #get comments
        $sth = $dbh->prepare(qq{select comments.id, comments.text, users.username, from_unixtime( comments.timestamp )
                                from comments, users where
                                comments.videoid=? and users.id=comments.userid}) or die $dbh->errstr;
        $sth->execute($id) or die $dbh->errstr;
        while (my ($commentid, $text, $username, $timestamp) = $sth->fetchrow_array())
        {
            push @{ $page->{'comments'}->{'comment'} }, {
                'text'      => [$text],
                'username'  => $username,
                'timestamp' => $timestamp,
                'id'        => $commentid
            };
        }
        
        #get referers
        $sth = $dbh->prepare(qq{select count, referer from referer where videoid=?}) or die $dbh->errstr;
        $sth->execute($id) or die $dbh->errstr;
        while (my ($count, $referer) = $sth->fetchrow_array())
        {
            $referer or $referer = 'no referer (refreshed, manually entered url or bookmark)';
            push @{ $page->{'referers'}->{'referer'} }, {
                'count'     => $count,
                'referer'   => $referer
            };
        }
        print output_page();
    }
}
else
{
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_202c";
    print output_page();
}
