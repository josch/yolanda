require "/var/www/perl/include.pl";
require "/var/www/perl/functions.pl";

CGI::Session->name($session_name);
$query = CGI->new(\&hook);
$session = new CGI::Session;

sub hook {
	#this is going to become an ajax progress bar
	my ($filename, $buffer, $bytes_read, $data) = @_;
	print sha256_hex($buffer);
	#open(TEMP, ">>/var/www/perl/videos/temp.temp") or die "cannot open";
	print "Read $bytes_read bytes of $filename\n";
	#close TEMP;
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
