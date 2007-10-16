#!/usr/bin/perl
require "include.pl";
require "functions.pl";

CGI::Session->name($session_name);
$query = CGI->new(\&hook);
$session = new CGI::Session;

sub hook
{hj
	#this is going to become an ajax progress bar
	#alternatively, reloading every N seconds (mozilla doesn't flicker)
	my ($filename, $buffer, $bytes_read, $data) = @_;
	#print $ENV{'CONTENT_LENGTH'};
	#print sha256_hex($buffer);
	#open(TEMP, ">>/var/www/perl/videos/temp.temp") or die "cannot open";
	#print "Read $bytes_read bytes of $filename\n";
	#close TEMP;
}
 
my $userid = get_userid_from_sid($session->id);

if($userid)
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass) or die $dbh->errstr;
	
	#video status:
	# 0 - new entry - nothing done yet
	# 1 - successfully uploaded
	# 2 - successfully converted
	# 3 - error: was not a valid video/format
	# 4 - error: video is a duplicate
	#do query
	my $sth = $dbh->prepare(qq{insert into videos (title, caption, userid, status, timestamp) values ( ?, ?, ?, 0, now())}) or die $dbh->errstr;
	
	#execute it
	$sth->execute($query->param("title"), $query->param("caption"), $userid) or die $dbh->errstr;

	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#prepare query
	$sth = $dbh->prepare(qq{select last_insert_id() }) or die $dbh->errstr;
	
	#execute it
	$sth->execute() or die $dbh->errstr;
	
	#save the resulting username
	my ($id) = $sth->fetchrow_array() or die $dbh->errstr;
	
	#finish query
	$sth->finish() or die $dbh->errstr;

	#save uploaded file into temppath
	$upload_filehandle = $query->upload("file");
	open(TEMPFILE, ">$gnutube_root/tmp/$id") or die "cannot open";
	while ( <$upload_filehandle> )
	{
		print TEMPFILE;
	}
	close TEMPFILE;
	
	print $session->header();
	print "passt";
	print $id;
	
	#disconnect db
	$dbh->disconnect() or die $dbh->errstr;
}
else
{
	print $session->header();
	print "nope...";
}
