require "/var/www/perl/include.pl";

#fill %querystring with everything that was passed via POST
read( STDIN, $tmpStr, $ENV{ "CONTENT_LENGTH" } );
@parts = split( /\&/, $tmpStr );
foreach $part (@parts) {
	( $name, $value ) = split( /\=/, $part );
	$queryString{ $name } = $value;
}

CGI::Session->name($session_name);
my $session = new CGI::Session;

if($queryString{ "user" } and $queryString{ "pass" }) {
	$dbh = DBI->connect("DBI:mysql:$database:$host", $user, $pass);
	$sth = $dbh->prepare(qq{insert into users (username, password) values ('user', password('pass'))}); 
	$sth->execute();
	$sth->finish();
	$dbh->disconnect();
	print $session->header();
	print "done";
} else {
	print $session->header();
	print '<form action="" method="POST"><p>
<input name="user" type="text" size="30" maxlength="30">
<input name="pass" type="password" size="30" maxlength="30">
<input type="submit" name="register" value=" register ">
</p></form>';
}
