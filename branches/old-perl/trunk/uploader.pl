require "functions.pl";

CGI::Session->name($config->{"page_cookie_name"});
$query = CGI->new(\&hook);
$session = new CGI::Session;

sub hook
{
    #this is going to become an ajax progress bar
    #alternatively, reloading every N seconds (mozilla doesn't flicker)
    my ($filename, $buffer, $bytes_read, $data) = @_;
    #print $ENV{'CONTENT_LENGTH'};
    #print sha256_hex($buffer);
    #open(TEMP, ">>/var/www/perl/videos/temp.temp") or die "cannot open";
    #print "Read $bytes_read bytes of $filename\n";
    #close TEMP;
}
 
@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

if($userinfo->{'id'} && $query->param("DC.Title") &&
    $query->param("DC.Description") && $query->param("DC.Subject"))
{
    #make new entry for video into the databse
    #FIXME: contributor, rights
    $dbh->do(qq{insert into uploaded (title, description, userid, timestamp,
            creator, subject, source, language, coverage, rights, license)
            values ( ?, ?, ?, unix_timestamp(), ?, ?, ?, ?, ?, ?, ? )}, undef,
            $query->param("DC.Title"), $query->param("DC.Description"), $userinfo->{'id'},
            $query->param("DC.Creator"), $query->param("DC.Subject"), $query->param("DC.Source"),
            $query->param("DC.Language"), $query->param("DC.Coverage"),
            $query->param("DC.Rights"), $query->param("DC.License")) or die $dbh->errstr;
    
    #get the id of the inserted db entry
    $sth = $dbh->prepare(qq{select last_insert_id() }) or die $dbh->errstr;
    $sth->execute() or die $dbh->errstr;
    my ($id) = $sth->fetchrow_array() or die $dbh->errstr;
    $sth->finish() or die $dbh->errstr;

    #save uploaded file into temppath
    $upload_filehandle = $query->upload("file");
    
    open(TEMPFILE, ">/tmp/$id");
    #check that nothing more than max filesize is being uploaded
    while ( <$upload_filehandle> )
    {
        print TEMPFILE;
    }
    close TEMPFILE;
    
    #check if file is too small or too big
    if( -s "/tmp/$id" < $config->{"video_filesize_min"})
    {
        #delete from uploaded table
        $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
        unlink "/tmp/$id";
        print $query->redirect("index.pl?error=error_upload_file_too_small&value=".$config->{"video_filesize_min"});
    }
    elsif( -s "/tmp/$id" > $config->{"video_filesize_max"})
    {
        #delete from uploaded table
        $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
        unlink "/tmp/$id";
        print $query->redirect("index.pl?error=error_upload_file_too_big&value=".$config->{"video_filesize_max"});
    }
    else
    {
        $info = `export SDL_VIDEODRIVER="dummy"; ffplay -stats -an -vn -nodisp /tmp/$id 2>&1`;
        
        if($info =~ /ignoring/)
        {
            #delete from uploaded table
            $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
            unlink "/tmp/$id";
            print $query->redirect("index.pl?error=error_upload_invalid_stream");
        }
        elsif ($info =~ /I\/O error occured/)
        {
            #delete from uploaded table
            $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
            unlink "/tmp/$id";
            print $query->redirect("index.pl?error=error_upload_io");
        }
        elsif ($info =~ /Unknown format/ or $info =~ /could not find codec parameters/)
        {
            #delete from uploaded table
            $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
            unlink "/tmp/$id";
            print $query->redirect("index.pl?error=error_upload_not_a_video");
        }
        else
        {
            #generate unique hash
            $sha = new Digest::SHA(256);
            $sha->addfile("/tmp/$id");
            $sha = $sha->hexdigest;
            
            #check if this hash is already in database
            my $sth = $dbh->prepare(qq{select id from videos where hash = ? limit 1}) or die $dbh->errstr;
            $sth->execute($sha) or die $dbh->errstr;
            my ($resultid) = $sth->fetchrow_array();
            $sth->finish() or die $dbh->errstr;
            
            #if so, then video is a duplicate (alternatively ALL HAIL QUANTUM COMPUTING)
            if($resultid)
            {
                #delete from uploaded table
                $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
                unlink "/tmp/$id";
                print $query->redirect("index.pl?error=error_upload_duplicate");
            }
            else
            {
                #get video container and duration
                ($container, $duration) = $info =~ /Input \#0, (\w+),.+?\n.+?Duration: (\d{2}:\d{2}:\d{2}\.\d)/;
                
                #get audio, video, idth, height and fps
                #these two regexes have to be applied seperately because nobody knows which stream (audio or video) comes first
                ($audio) = $info =~ /Audio: (\w+)/;
                ($video, $width, $height, $fps) = $info =~ /Video: ([\w\d]+),.+?(\d+)x(\d+),.+?(\d+\.\d+) fps/;
                
                #if there is no video stream or no duration
                if(!$video or !$duration)
                {
                    #delete from uploaded table
                    $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
                    unlink "/tmp/$id";
                    print $query->redirect("index.pl?error=error_upload_invalid_stream");
                }
                #if the video width is smaller than allowed
                elsif($width < $config->{"video_width_min"})
                {
                    #delete from uploaded table
                    $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
                    unlink "/tmp/$id";
                    print $query->redirect("index.pl?error=error_upload_video_width_too_small&value=".$config->{"video_width_min"});
                }
                #if the video height is smaller than allowed
                elsif($height < $config->{"video_height_min"})
                {
                    #delete from uploaded table
                    $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
                    unlink "/tmp/$id";
                    print $query->redirect("index.pl?error=error_upload_video_height_too_small&value=".$config->{"video_height_min"});
                }
                else
                {
                    #get video filesize
                    $filesize = -s "/tmp/$id";
                    
                    #convert hh:mm:ss.s duration to full seconds - thanks perl for making this so damn easy!
                    #don't want to know how this would look in python or php... hell I don't even have to create extra variables!
                    $duration =~ /^(\d{2}):(\d{2}):(\d{2})\.(\d)$/;
                    $duration = int($1*3600 + $2*60 + $3 + $4/10 + .5);
                    
                    #get thumbnail position
                    $thumbnailsec = int(rand($duration));
                    $previewsec = $thumbnailsec;
                    
                    #the width/height calculation could of course be much shorter but less readable then
                    #all thumbs have equal height
                    $tnheight = $config->{"video_thumbnail_height"};
                    $tnwidth = int($tnheight*($width/$height)/2 + .5)*2;
                    
                    #create thumbnail and preview in original size
                    $ffthumb = system "ffmpeg -i /tmp/$id -vcodec mjpeg -vframes 1 -an -f rawvideo -ss $thumbnailsec -s ".$tnwidth."x$tnheight $root/video-stills/thumbnails/$id";
                    $ffprev = system "ffmpeg -i /tmp/$id -vcodec mjpeg -vframes 1 -an -f rawvideo -ss $previewsec $root/video-stills/previews/$id";
                    
                    #if thumbnail was created successfully
                    if($ffthumb == 0 and $ffprev == 0)
                    {
                        #check if the upload already is in the right format and smaller/equal max-width/height
                        if ($container eq 'ogg' and $video eq 'theora' and ($audio eq 'vorbis' or not $audio) and $height <= $config->{"video_height_max"} and $width <= $config->{"video_width_max"})
                        {
                            #if so, move to destination
                            if(move("/tmp/$id", "$root/videos/$id"))
                            {
                                #if move was successful
                                #add video to videos table
                                $dbh->do(qq{insert into videos select id, title, description, userid, timestamp, creator,
                                                        subject, source, language, coverage, rights, license, ?, ?, ?, ?, ?, ?, 0, 0
                                                        from uploaded where id = ?}, undef, $filesize, $duration, $width,
                                                        $height, $fps, $sha, $id) or die $dbh->errstr;
                                                        
                                #delete from uploaded table
                                $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
                            }
                            else
                            {
                                #delete from uploaded table
                                $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
                                die "cannot move video to $root/videos/$id - check your permissions!"
                            }
                        }
                        else
                        {
                            #write all valueable information to database so the daemon can fetch it
                            $dbh->do(qq{update uploaded set filesize = ?, duration = ?, width = ?,
                                    height = ?, fps = ?, hash = ? where id = ?}, undef, $filesize, $duration, $width,
                                    $height, $fps, $sha, $id) or die $dbh->errstr;
                        }
                        
                        #print success to the user
                        print $query->redirect("index.pl?information=information_uploaded&value=".$config->{"url_root"}."/video/".urlencode($query->param("DC.Title"))."/$id/");
                    }
                    else
                    {
                        #delete from uploaded table
                        $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or die $dbh->errstr;
                        die "cannot create thumbnails - check your permissions!";
                    }
                }
            }
        }
    }
}
else
{
    #print $query->redirect("index.pl?error=error_202c");
}
