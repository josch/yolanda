sub fill_tagcloud {
	my $sth = $dbh->prepare(qq{select text, count from tagcloud });
	$sth->execute();
	while (my ($text, $count) = $sth->fetchrow_array())
	{
	  push @{ $page->{tagcloud}->{tag} }, { text => [$text], count => [$count] };
	}
	$sth->finish();
	$dbh->disconnect();
}

1;
