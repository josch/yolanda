#!/usr/bin/perl -w

use Proc::Daemon;
use DBI;
use Digest::SHA;
use File::Copy;

$database = 'yolanda';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$root = '/var/www/yolanda';

#TODO: deamonize by uncommenting this line
#Proc::Daemon::Init;

$LOG = "$root/daemon.log";


sub appendlog
{
	if (open(FILE, ">>$LOG"))
	{
		print FILE scalar(localtime)." ".$$." ".join(" ",@_)."\n";
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
		$info = `ffplay -stats -an -vn -nodisp $root/tmp/$id 2>&1`;
		
		if($info =~ /ignoring/)
		{
			appendlog $id, "invalid stream";
			
			#write status 2 to uploaded table
			$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 2, $id) or interrupt $dbh->errstr;
			unlink "$root/tmp/$id";
		}
		elsif ($info =~ /I\/O error occured/)
		{
			appendlog $id, "file not found";
			
			#write status 3 to uploaded table
			$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 3, $id) or interrupt $dbh->errstr;
			unlink "$root/tmp/$id";
		}
		elsif ($info =~ /Unknown format/ or $info =~ /could not find codec parameters/)
		{
			appendlog $id, "file is no video";
			
			#write status 4 to uploaded table
			$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 4, $id) or interrupt $dbh->errstr;
			unlink "$root/tmp/$id";
		}
		else
		{
			$sha = new Digest::SHA(256);
			$sha->addfile("$root/tmp/$id");
			$sha = $sha->hexdigest;
			
			#check if this hash is already in database
			my $sth = $dbh->prepare(qq{select id from videos where hash = ? limit 1}) or interrupt $dbh->errstr;
			$sth->execute($sha) or interrupt $dbh->errstr;
			my ($resultid) = $sth->fetchrow_array();
			$sth->finish() or interrupt $dbh->errstr;
			
			#if so, then video is a duplicate
			if($resultid)
			{
				appendlog "$id, video already uploaded: $resultid";
				
				#write status 5 to uploaded table
				$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 5, $id) or interrupt $dbh->errstr;
				unlink "$root/tmp/$id";
			}
			else
			{
				($container, $duration) = $info =~ /Input \#0, (\w+),.+?\n.+?Duration: (\d{2}:\d{2}:\d{2}\.\d)/;
				
				#these two regexes have to be applied seperately because nobody knows which stream (audio or video) comes first
				($audio) = $info =~ /Audio: (\w+)/;
				($video, $width, $height, $fps) = $info =~ /Video: (\w+),.+?(\d+)x(\d+),.+?(\d+\.\d+) fps/;
				
				if(!$audio or !$video or !$duration)
				{
					appendlog $id, "a stream is missing or video is corrupt";
					
					#write status 2 to uploaded table
					$dbh->do(qq{update uploaded set status = ? where id = ?}, undef, 2, $id) or interrupt $dbh->errstr;
					unlink "$root/tmp/$id";
				}
				else
				{
					#TODO: maybe delete entry from uploaded table after successful upload?
					$filesize = -s "$root/tmp/$id";
					
					#convert hh:mm:ss.s duration to full seconds - thanks perl for making this so damn easy!
					#don't want to know how this would look in python or php... hell I don't even have to create extra variables!
					$duration =~ /^(\d{2}):(\d{2}):(\d{2})\.(\d)$/;
					$duration = int($1*3600 + $2*60 + $3 + $4/10 + .5);
					
					#create thumbnail
					$thumbnailsec = int($duration/3 + .5);
					
					#the width/height calculation could of course be much shorter but less readable then
					$tnmaxwidth = 160;
					$tnmaxheight = 120
					$tnwidth = $tnmaxwidth;
					$tnheight = int($tnwidth*($height/$width)/2 + .5)*2;
					if($tnheight > $tnmaxheight)
					{
						$tnheight = $tnmaxheight;
						$tnwidth = int($tnheight*($width/$height)/2 + .5)*2;
					}
					system "ffmpeg -i $root/tmp/$id -vcodec mjpeg -vframes 1 -an -f rawvideo -ss $thumbnailsec -s ".$tnwidth."x$tnheight $root/video-stills/$id";
					
					#check if the upload already is in the right format
					if ($container eq 'ogg' and $video eq 'theora' and $audio eq 'vorbis')
					{
						appendlog $id, "file already is ogg-theora/vorbis";
						
						#add video to videos table
						$dbh->do(qq{insert into videos select id, title, description, userid, timestamp, creator,
												subject, contributor, source, language, coverage, rights, license, notice,
												derivativeworks, sharealike, commercialuse, ?, ?, ?, ?, ?, ?, 0, 0
												from uploaded where id = ?}, undef, $filesize, $duration, $width,
												$height, $fps, $sha, $id) or interrupt $dbh->errstr;
						
						#move video
						move "$root/tmp/$id", "$root/videos/$id";
					}
					else #encode video
					{
						#TODO: addmetadata information
						system "ffmpeg2theora --optimize --videobitrate 1000 --audiobitrate 64 --sharpness 0 --output $root/videos/$id $root/tmp/$id 2>&1";
						appendlog $id, $audio, $video, $width, $height, $fps, $duration, $sha;
						
						#add video to videos table
						$dbh->do(qq{insert into videos select id, title, description, userid, timestamp, creator,
												subject, contributor, source, language, coverage, rights, license, notice,
												derivativeworks, sharealike, commercialuse, ?, ?, ?, ?, ?, ?, 0, 0
												from uploaded where id = ?}, undef, $filesize, $duration, $width,
												$height, $fps, $sha, $id) or interrupt $dbh->errstr;
						
						#delete temp file
						unlink "$root/tmp/$id";
					}
					
					#delete from uploaded table
					$dbh->do(qq{delete from uploaded where id = ?}, undef, $id) or interrupt $dbh->errstr;
				}
			}
		}
	}
	else
	{
		sleep 10;
	}
}
