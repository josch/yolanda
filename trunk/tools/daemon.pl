#!/usr/bin/perl -w

use Proc::Daemon;
use DBI;
use Digest::SHA;
use File::Copy;

#TODO: put this into central configuration file
$database = 'yolanda';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$root = '/var/www/yolanda';

#TODO: deamonize by uncommenting this line
#Proc::Daemon::Init;

$LOG = "/dev/null";


#TODO: maybe keep file open the whole time ?
sub appendlog
{
    if (open(FILE, ">>$LOG"))
    {
        print FILE scalar(localtime)." ".$$."\n";
        print "------------------------------------\n";
        print join("\n",@_)."\n";
        print "------------------------------------\n\n";
        close FILE;
    }
}

sub interrupt
{
    appendlog(@_);
    die;
}

$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or interrupt "could not connect to db";

while(1)
{
    #get fresh video id from db
    my $sth = $dbh->prepare(qq{select id, filesize, duration, width, height, fps, hash
        from uploaded where filesize != -1 and duration != -1 and width != -1 and height != -1 limit 1}) or interrupt $dbh->errstr;
        
    $sth->execute() or interrupt $dbh->errstr;
    my ($id,$filesize, $duration, $width, $height, $fps, $sha) = $sth->fetchrow_array();
    $sth->finish() or interrupt $dbh->errstr;
    
    if($id)
    {
        $vmaxheight = 640;
        
        #video height is either the maximum video height
        #or (when the original is smaller than that) the original height
        #check for multiple by 8
        $vheight = $vmaxheight <= $height ? $vmaxheight : int($height/8 + .5)*8;
        $vwidth = int($vheight*($width/$height)/8 + .5)*8;
        
        $abitrate = 64;
        $vbitrate = int((int(($filesize*8) / $duration + .5) - $abitrate)/1000);
        #check if the bitrate is lower than 16000 (maximum for ffmpeg)
        $vbitrate = $vbitrate <= 16000 ? $vbitrate : 16000;
        
        #TODO: add metadata information
        $ffmpeg = system "ffmpeg2theora --optimize --videobitrate $vbitrate --audiobitrate $abitrate --sharpness 0 --width $vwidth --height $vheight --output $root/videos/$id /tmp/$id";
        
        appendlog $id, $vbitrate, $filesize, $vwidth, $vheight, $fps, $duration, $sha, $ffmpeg;
        
        #only insert into videos table when everything went right
        if($ffmpeg == 0)
        {
            $filesize = -s "$root/videos/$id";
            
            #add video to videos table
            $dbh->do(qq{insert into videos select id, title, description, userid, timestamp, creator,
                                    subject, source, language, coverage, rights, license, ?, duration, ?, ?, fps, hash, 0, 0
                                    from uploaded where id = ?}, undef, $filesize, $vwidth,
                                    $vheight, $id) or interrupt $dbh->errstr;
        }
        
        #delete from uploaded table and from /tmp
        unlink "/tmp/$id";
        $dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or interrupt $dbh->errstr;
    }
    else
    {
        #TODO: maybe make this event-driven by using the kernels has-this-file-changed-interface ?
        sleep 10;
    }
}
