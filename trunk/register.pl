require "/var/www/perl/include.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

#if username and password are passed put them into the database
if($query->param('user') and $query->param('pass')) {
	#connect to db
	$dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass);
	
	#save POST data in local variables
	my $user = $query->param("user");
	my $pass = $query->param("pass");
	
	#prepare query
	$sth = $dbh->prepare(qq{insert into users (username, password) values ('$user', password('$pass'))});
	
	#execute query
	$sth->execute();
	
	#finish query
	$sth->finish();
	
	#disconnect db
	$dbh->disconnect();
	
	#print a little confirmation
	print $session->header();
	print "done";
} else {
	#if not, print register form
	print $session->header();
	print '<form action="" method="POST"><p>
<input name="user" type="text" size="30" maxlength="30">
<input name="pass" type="password" size="30" maxlength="30">
<input type="submit" name="register" value=" register ">
</p></form>';
}
