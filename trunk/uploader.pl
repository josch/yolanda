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
	open(TEMPFILE, ">$root/tmp/$id") or die "cannot open $root/tmp/$id";
	while ( <$upload_filehandle> )
	{
		print TEMPFILE;
	}
	close TEMPFILE;
	
	print $query->redirect("index.pl?information=information_uploaded&value=$domain/video/".urlencode($query->param("DC.Title"))."/$id/");
}
else
{
	print $query->redirect("index.pl?error=error_202c");
}
