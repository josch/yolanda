require "/var/www/perl/include.pl";

#fill %querystring with everything that was passed via GET
@parts = split( /\&/, $ENV{ "QUERY_STRING" } );
foreach $part (@parts) {
	( $name, $value ) = split( /\=/, $part );
	$queryString{ $name } = $value;
}

#fill %querystring with everything that was passed via POST
read( STDIN, $tmpStr, $ENV{ "CONTENT_LENGTH" } );
@parts = split( /\&/, $tmpStr );
foreach $part (@parts) {
	( $name, $value ) = split( /\=/, $part );
	$queryString{ $name } = $value;
}

CGI::Session->name($session_name);
my $session = new CGI::Session;

if($queryString{ "action" }) {
	if($queryString{ "action" } eq "login") {
		$dbh = DBI->connect("DBI:mysql:$database:$host", $user, $pass);
		my $sth = $dbh->prepare(qq{select username from users
				where password = password('$queryString{ "pass" }')
				and username = '$queryString{ "user" }'
				limit 1 });
		$sth->execute();
		
		if($sth->fetchrow_array()) {
			$session->param('auth', 'true');
			print $session->header();
			print "logged in";
		} else {
			print $session->header();
			print $queryString{ "action" };
		}
		
		$sth->finish();
		$dbh->disconnect();
		
	} elsif($queryString{ "action" } eq "logout") {
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
