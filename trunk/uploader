require "/var/www/perl/include.pl";
require "/var/www/perl/functions.pl";

CGI::Session->name($session_name);
$query = CGI->new(\&hook);
$session = new CGI::Session;
#$query = new CGI;

sub hook {
	my ($filename, $buffer, $bytes_read, $data) = @_;
	open(TEMP, ">/var/www/perl/temp.temp") or die "cannot open";
	print TEMP "Read $bytes_read bytes of $filename\n";
	close TEMP;
}
 
my $username = get_username_from_sid($session->id);

if($username) {
	my $filename = $query->param("file");
	my $title = $query->param("title");
	$upload_filehandle = $query->upload("file");
	print $session->header();
	while ( <$upload_filehandle> )
	{
		print;
	}
} else {
	print $session->header();
	print "nope...";
}
