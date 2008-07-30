require "functions.pl";

#initialize session data
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

#do we have an id?
if($query->param('id'))
{
    #check if video with requested id is in the database
    my $sth = $dbh->prepare(qq{select title from videos where id = ? });
    $sth->execute($query->param('id'));
    
    if(($title) = $sth->fetchrow_array())
    {   
        #are we only watching this video or downloading it?
        if($query->param('view'))
        {
            #seems we only want to watch it - update viewcount
            $dbh->do(qq{update videos set viewcount=viewcount+1 where id = ? }, undef, $query->param('id')) or die $dbh->errstr;
        }
        else
        {
            #video is being downloaded - update downloadcount
            $dbh->do(qq{update videos set downloadcount=downloadcount+1 where id = ? }, undef, $query->param('id')) or die $dbh->errstr;
        }
        
        #open video file
        $file = open(FILE, "<$root/videos/".$query->param('id'));
        
        if($file)
        {
            #TODO: replace all of this with fastcgi x-sendfile
            #get video filesize
            $filesize = -s "$root/videos/".$query->param('id');
            
            #get http query range
            #TODO: also allow range end
            $range = $query->http('range');
            $range =~ s/bytes=([0-9]+)-/$1/;
            
            #if a specific range is requested send http partial content headers and seek in the inputfile
            if($range)
            {
                #if $range is equal or more than filesize throw http 416 header
                if($range >= $filesize)
                {
                    print $query->header(-status=>'416 Requested Range Not Satisfiable');
                }
                else
                {
                    #print correct http partial header
                    print $query->header(-type=>'application/ogg',
                            -content_length=> $filesize-$range,
                            -status=>'206 Partial Content',
                            -attachment=>$title.".ogv",
                            -accept_ranges=> "bytes",
                            -content_range=> "bytes $range-".($filesize-1)."/$filesize"
                            );
                    
                    #seek file to the requested position
                    seek FILE, $range, 0;
                }
            }
            else
            {
                #print normal header
                print $query->header(-type=>'application/ogg',
                        -content_length=> $filesize,
                        -attachment=>$title.".ogv"
                        );
            }
            
            #in both cases - do some slurp-eaze to the browser
            while (my $BytesRead = read (FILE, $buff, 8192))
            {
                print $buff;
            }
            close(FILE);
        }
        else
        {
            #the requested file should be there but is not - throw server error
            print $session->header(
                -status=>'500 Internal Server Error'
            )
        }
    }
    else
    {
        #no such video exists - 404
        print $session->header(
            -status=>'404 Not found'
        )
    }
}
else
{
    #no if was supplied
    print $query->redirect("index.pl?error=error_202c");
}
