#!/usr/bin/perl
require "include.pl";
require "functions.pl";

CGI::Session->name($session_name);
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
 
my $userid = get_userid_from_sid($session->id);

if($userid)
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass) or die $dbh->errstr;
	
	#make new entry for video into the databse
	my $sth = $dbh->prepare(qq{insert into uploaded (title, description, userid, timestamp) values ( ?, ?, ?, unix_timestamp())}) or die $dbh->errstr;
	$sth->execute($query->param("DC.Title"), $query->param("DC.Description"), $userid) or die $dbh->errstr;
	$sth->finish() or die $dbh->errstr;
	
	#get the id of the inserted db entry
	$sth = $dbh->prepare(qq{select last_insert_id() }) or die $dbh->errstr;
	$sth->execute() or die $dbh->errstr;
	my ($id) = $sth->fetchrow_array() or die $dbh->errstr;
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
