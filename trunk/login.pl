require "/var/www/perl/include.pl";

CGI::Session->name($session_name);
my $session = new CGI::Session;

#fill %querystring with everything that was passed via GET
@parts = split( /\&/, $ENV{ "QUERY_STRING" } );
foreach $part (@parts) {
	( $name, $value ) = split( /\=/, $part );
	$queryString{ $name } = $value;
}

if($queryString{ "action" }) {
	if($queryString{ "action" } eq "login") {
		$session->param('auth', 'true');
		print $session->header();
		print "logged in";
	} elsif($queryString{ "action" } eq "logout") {
		$session->param('auth', 'false');
		print $session->header();
		print "logged out";
	}
} else {
	print $session->header();
	print "incorrect query string";
}
