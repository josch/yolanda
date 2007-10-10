require "/var/www/perl/include.pl";

#get tags from database and fill $page with xml
sub fill_tagcloud {
	#connect to db
	$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);
	
	#prepare query
	my $sth = $dbh->prepare(qq{select text, count from tagcloud });
	
	#execute it
	$sth->execute();
	
	#get every returned value
	while (my ($text, $count) = $sth->fetchrow_array())
	{
		#push the new value to the $page->tagcloud array
		push @{ $page->{tagcloud}->{tag} }, { text => [$text], count => [$count] };
	}
	
	#finish query
	$sth->finish();
	
	#close db
	$dbh->disconnect();
}

#return a username from passed session id
sub get_username_from_sid {
	#get parameters
	my ($sid) = @_;
	
	#connect to db
	$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);
	
	#prepare query
	my $sth = $dbh->prepare(qq{select username from users where sid = '$sid'});
	
	#execute it
	$sth->execute();
	
	#save the resulting username
	my ($username) = $sth->fetchrow_array();
	
	#finish query
	$sth->finish();
	
	#close db
	$dbh->disconnect();
	
	#return username
	return $username;
}
