require "/var/www/perl/include.pl";

CGI::Session->name($session_name);
$session = new CGI::Session;
$query = new CGI;

if($query->param('user') and $query->param('pass')) {
	$dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass);
	my $user = $query->param("user");
	my $pass = $query->param("pass");
	$sth = $dbh->prepare(qq{insert into users (username, password) values ('$user', password('$pass'))}); 
	$sth->execute();
	$sth->finish();
	$dbh->disconnect();
	print $session->header();
	print "done" . $query->param('pass');
} else {
	print $session->header();
	print '<form action="" method="POST"><p>
<input name="user" type="text" size="30" maxlength="30">
<input name="pass" type="password" size="30" maxlength="30">
<input type="submit" name="register" value=" register ">
</p></form>';
}
