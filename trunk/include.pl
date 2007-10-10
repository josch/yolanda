use CGI::Session;
use DBI;
use XML::Simple qw(:strict);
$dbh = DBI->connect('DBI:mysql:gnutube:localhost', 'root', '');
