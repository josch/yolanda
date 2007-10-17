#!/usr/bin/perl -w

use Proc::Daemon;
use DBI;
use Digest::SHA;

$database = 'gnutube';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$gnutube_root = '/var/www/gnutube';

#Proc::Daemon::Init;

$LOG = "/var/www/gnutube/daemon.log";


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
	my $sth = $dbh->prepare(qq{select id from videos where status = 0 limit 1}) or interrupt $dbh->errstr;
	$sth->execute() or interrupt $dbh->errstr;
	my ($id) = $sth->fetchrow_array();
	$sth->finish() or interrupt $dbh->errstr;
	
	if($id)
	{
		$info = `ffplay -stats -an -vn -nodisp $gnutube_root/tmp/$id 2>&1`;
		
		if($info =~ /ignoring/)
		{
			appendlog $id, "invalid stream";
			
			#write status 2 to database
			$sth = $dbh->prepare(qq{update videos set status = ? where id = ?}) or interrupt $dbh->errstr;
			$sth->execute(2, $id) or interrupt $dbh->errstr;
			$sth->finish() or interrupt $dbh->errstr;
		}
		elsif ($info =~ /I\/O error occured/)
		{
			appendlog $id, "file not found";
			
			#write status 3 to database
			$sth = $dbh->prepare(qq{update videos set status = ? where id = ?}) or interrupt $dbh->errstr;
			$sth->execute(3, $id) or interrupt $dbh->errstr;
			$sth->finish() or interrupt $dbh->errstr;
		}
		elsif ($info =~ /Unknown format/ or $info =~ /could not find codec parameters/)
		{
			appendlog $id, "file is no video";
			
			#write status 4 to database
			$sth = $dbh->prepare(qq{update videos set status = ? where id = ?}) or interrupt $dbh->errstr;
			$sth->execute(4, $id) or interrupt $dbh->errstr;
			$sth->finish() or interrupt $dbh->errstr;
		}
		else
		{
			$sha = new Digest::SHA(256);
			$sha->addfile("$gnutube_root/tmp/$id");
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
				
				#write status 5 to database
				$sth = $dbh->prepare(qq{update videos set status = ? where id = ?}) or interrupt $dbh->errstr;
				$sth->execute(5, $id) or interrupt $dbh->errstr;
				$sth->finish() or interrupt $dbh->errstr;
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
					
					#write status 2 to database
					$sth = $dbh->prepare(qq{update videos set status = ? where id = ?}) or interrupt $dbh->errstr;
					$sth->execute(2, $id) or interrupt $dbh->errstr;
					$sth->finish() or interrupt $dbh->errstr;
				}
				else
				{
					$filesize = -s "$gnutube_root/tmp/$id";
					
					#check if the upload already is in the right format
					if ($container eq 'ogg' and $video eq 'theora' and $audio eq 'vorbis')
					{
						appendlog $id, "file already is ogg-theora/vorbis";
						
						#fill database
						$sth = $dbh->prepare(qq{update videos set
												status = ?,
												hash = ?,
												filesize = ?,
												duration = time_to_sec( ? ),
												width = ?,
												height = ?,
												fps = ?
												where id = ?}) or interrupt $dbh->errstr;
						$sth->execute(1, $sha, $filesize, $duration, $width, $height, $fps, $id) or interrupt $dbh->errstr;
						$sth->finish() or interrupt $dbh->errstr;
						#TODO move video
					}
					else #encode video
					{
					
						#TODO uncomment the following line
						#exec "ffmpeg2theora --optimize --videobitrate 1000 --audiobitrate 64 --sharpness 0 --endtime 10 --output $gnutube_root/videos/$id $gnutube_root/tmp/$id 2>&1";
						appendlog $id, $audio, $video, $width, $height, $fps, $duration, $sha;
						
						#fill database
						$sth = $dbh->prepare(qq{update videos set
												status = ?,
												hash = ?,
												filesize = ?,
												duration = time_to_sec( ? ),
												width = ?,
												height = ?,
												fps = ?
												where id = ?}) or interrupt $dbh->errstr;
						$sth->execute(1, $sha, $filesize, $duration, $width, $height, $fps, $id) or interrupt $dbh->errstr;
						$sth->finish() or interrupt $dbh->errstr;
						#TODO delete temp file
					}
				}
			}
		}
	}
	else
	{
		sleep 10;
	}
}
