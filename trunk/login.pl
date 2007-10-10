require "/var/www/perl/include.pl";

CGI::Session->name($session_name);
$session = new CGI::Session;
$query = new CGI;

if($query->param('action')) {
	if($query->param('action') eq "login") {
		$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);
		my $user = $query->param('user');
		my $pass = $query->param('pass');
		my $sth = $dbh->prepare(qq{select username from users
				where password = password('$pass')
				and username = '$user'
				limit 1 });
		$sth->execute();
		
		if($sth->fetchrow_array()) {
			$session->param('auth', 'true');
			print $session->header();
			print "logged in";
		} else {
			print $session->header();
			print $query->param('action');
		}
		
		$sth->finish();
		$dbh->disconnect();
		
	} elsif($query->param('action') eq "logout") {
		$session->param('auth', 'false');
		print $session->header();
		print "logged out";
	} else {
		print $session->header();
		print "wtf?";
	}
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
