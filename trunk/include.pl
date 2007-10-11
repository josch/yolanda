use CGI qw(:standard);
use CGI::Session;
use DBI;
use XML::Simple qw(:strict);
use Digest::SHA;
#use Digest::SHA qw(sha256_hex);

#set global variables
$database = 'gnutube';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$session_name = 'sid';
1;
