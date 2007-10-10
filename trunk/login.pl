require "/var/www/perl/include.pl";

CGI::Session->name($session_name);
$session = new CGI::Session;
$query = new CGI;

if($query->param('action')) {
	$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);

	if($query->param('action') eq "login") {
		my $user = $query->param('user');
		my $pass = $query->param('pass');
		my $sth = $dbh->prepare(qq{select username from users
				where password = password('$pass')
				and username = '$user'
				limit 1 });
		$sth->execute();
		
		if($sth->fetchrow_array()) {
			my $sid = $session->id;
			$sth = $dbh->prepare(qq{update users set sid = '$sid' where username = '$user'}); 
			$sth->execute();
			$sth->finish();
			print $session->header();
			print "logged in";
		} else {
			print $session->header();
			print "could not log you in";
		}
		
	} elsif($query->param('action') eq "logout") {
		$sth = $dbh->prepare(qq{update users set sid = '' where username = '$user'}); 
		$sth->execute();
		$sth->finish();
		$session->delete();
		print $session->header();
		print "logged out";
	} else {
		print $session->header();
		print "wtf?";
	}

	$dbh->disconnect();
} else {
	print $session->header();
	print '<form action="" method="POST"><p>
<input name="action" type="hidden" value="login">
<input name="user" type="text" size="30" maxlength="30">
<input name="pass" type="password" size="30" maxlength="30">
<input type="submit" name="login" value=" login ">
</p></form>';
	print STDIN;
}
