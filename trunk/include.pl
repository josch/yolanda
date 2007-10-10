use CGI qw(:standard);
use CGI::Session;
use DBI;
use XML::Simple qw(:strict);

$database = 'gnutube';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$session_name = 'sid';
1;
