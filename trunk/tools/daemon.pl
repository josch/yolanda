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

$LOG = "$root/daemon.log";


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

#video status:
# 0 - new entry - nothing done yet
# 1 - valid public video
# 2 - error: invalid audio and/or video stream
# 3 - error: file not found
# 4 - error: file is not a video
# 5 - error: video is a duplicate

while(1)
{
	#get fresh video id from db
	my $sth = $dbh->prepare(qq{select id from uploaded where status = 0 limit 1}) or interrupt $dbh->errstr;
		
	$sth->execute() or interrupt $dbh->errstr;
	my ($id) = $sth->fetchrow_array();
	$sth->finish() or interrupt $dbh->errstr;
	
	if($id)
	{
		$info = `export SDL_VIDEODRIVER="dummy"; ffplay -stats -an -vn -nodisp /tmp/$id 2>&1`;
		
		if($info =~ /ignoring/)
		{
			appendlog "id: $id",
				"error: invalid stream",
				"ffplay msg: $info";
			
			#write status 2 to uploaded table
			$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 2, $id) or interrupt $dbh->errstr;
			unlink "/tmp/$id";
		}
		elsif ($info =~ /I\/O error occured/)
		{
			appendlog "id: $id",
				"error: file not found",
				"ffplay msg: $info";
			
			#write status 3 to uploaded table
			$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 3, $id) or interrupt $dbh->errstr;
			unlink "/tmp/$id";
		}
		elsif ($info =~ /Unknown format/ or $info =~ /could not find codec parameters/)
		{
			appendlog "id: $id",
				"error: file is of unknown format",
				"ffplay msg: $info";
			
			#write status 4 to uploaded table
			$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 4, $id) or interrupt $dbh->errstr;
			unlink "/tmp/$id";
		}
		else
		{
			$sha = new Digest::SHA(256);
			$sha->addfile("/tmp/$id");
			$sha = $sha->hexdigest;
			
			#check if this hash is already in database
			my $sth = $dbh->prepare(qq{select id from videos where hash = ? limit 1}) or interrupt $dbh->errstr;
			$sth->execute($sha) or interrupt $dbh->errstr;
			my ($resultid) = $sth->fetchrow_array();
			$sth->finish() or interrupt $dbh->errstr;
			
			#if so, then video is a duplicate (alternatively ALL HAIL QUANTUM COMPUTING)
			if($resultid)
			{
				appendlog  "id: $id",
					"error: video already uploaded: $resultid";
				
				#write status 5 to uploaded table
				$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 5, $id) or interrupt $dbh->errstr;
				unlink "/tmp/$id";
			}
			else
			{
				($container, $duration) = $info =~ /Input \#0, (\w+),.+?\n.+?Duration: (\d{2}:\d{2}:\d{2}\.\d)/;
				
				#these two regexes have to be applied seperately because nobody knows which stream (audio or video) comes first
				($audio) = $info =~ /Audio: (\w+)/;
				($video, $width, $height, $fps) = $info =~ /Video: ([\w\d]+),.+?(\d+)x(\d+),.+?(\d+\.\d+) fps/;
				
				if(!$audio or !$video or !$duration)
				{
					appendlog "id: $id",
						"error: error: stream is missing or video is corrupt",
						"audio: $audio",
						"video: $video",
						"duration: $duration",
						"ffplay msg: $info";
					
					#write status 2 to uploaded table
					$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 2, $id) or interrupt $dbh->errstr;
					unlink "/tmp/$id";
				}
				else
				{
					$filesize = -s "/tmp/$id";
					
					#convert hh:mm:ss.s duration to full seconds - thanks perl for making this so damn easy!
					#don't want to know how this would look in python or php... hell I don't even have to create extra variables!
					$duration =~ /^(\d{2}):(\d{2}):(\d{2})\.(\d)$/;
					$duration = int($1*3600 + $2*60 + $3 + $4/10 + .5);
					
					#create thumbnail
					$thumbnailsec = int($duration/3 + .5);
					
					#the width/height calculation could of course be much shorter but less readable then
					#all thumbs have equal height
					$tnmaxheight = 120;
					$tnheight = $tnmaxheight;
					$tnwidth = int($tnheight*($width/$height)/2 + .5)*2;
					
					system "ffmpeg -i /tmp/$id -vcodec mjpeg -vframes 1 -an -f rawvideo -ss $thumbnailsec -s ".$tnwidth."x$tnheight $root/video-stills/$id";
					
					$vmaxheight = 640;
					
					#check if the upload already is in the right format and smaller/equal max-width/height
					if ($container eq 'ogg' and $video eq 'theora' and $audio eq 'vorbis' and $height <= $vmaxheight)
					{
						appendlog $id, "file already is ogg-theora/vorbis";
						
						#add video to videos table
						$dbh->do(qq{insert into videos select id, title, description, userid, timestamp, creator,
												subject, source, language, coverage, rights, license, ?, ?, ?, ?, ?, ?, 0, 0
												from uploaded where id = ?}, undef, $filesize, $duration, $width,
												$height, $fps, $sha, $id) or interrupt $dbh->errstr;
						
						#move video
						move "/tmp/$id", "$root/videos/$id";
					}
					else #encode video
					{
						#video height is either ther maximum video height
						#or when the original is smaller than that the original height
						#check for multiple by 8
						$vheight = $vmaxheight <= $height ? $vmaxheight : int($height/8 + .5)*8;
						$vwidth = int($vheight*($width/$height)/8 + .5)*8;
						
						$abitrate = 64;
						$vbitrate = int($filesize*8) / $duration + .5) - $abitrate;
						
						#TODO: add metadata information
						system "ffmpeg2theora --optimize --videobitrate $vbitrate --audiobitrate $abitrate --sharpness 0 --width $vwidth --height $vheight --output $root/videos/$id /tmp/$id";
						
						appendlog $id, $audio, $video, $vwidth, $vheight, $fps, $duration, $sha;
						
						$filesize = -s "$root/videos/$id";
						
						#add video to videos table
						$dbh->do(qq{insert into videos select id, title, description, userid, timestamp, creator,
												subject, source, language, coverage, rights, license, ?, ?, ?, ?, ?, ?, 0, 0
												from uploaded where id = ?}, undef, $filesize, $duration, $vwidth,
												$vheight, $fps, $sha, $id) or interrupt $dbh->errstr;
						
						#delete temp file
						unlink "/tmp/$id";
					}
					
					#create torrent file
					
					
					#delete from uploaded table
					$dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or interrupt $dbh->errstr;
				}
			}
		}
	}
	else
	{
		TODO: maybe make this event-driven by using the kernels has-this-file-changed-interface ?
		sleep 10;
	}
}
