#!/usr/bin/perl
require "include.pl";

#get tags from database and fill $page with xml
sub fill_tagcloud
{
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select text, count from tagcloud }) or die $dbh->errstr;
	
	#execute it
	$sth->execute() or die $dbh->errstr;
	
	#get every returned value
	while (my ($text, $count) = $sth->fetchrow_array())
	{
		#push the new value to the $page->tagcloud array
		push @{ $page->{tagcloud}->{tag} }, { text => [$text], count => [$count] };
	}
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
}

#return a username from passed session id
sub get_username_from_sid
{
	#get parameters
	my ($sid) = @_;
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select username from users where sid = ?}) or die $dbh->errstr;
	
	#execute it
	$sth->execute($sid) or die $dbh->errstr;
	
	#save the resulting username
	my ($username) = $sth->fetchrow_array();
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
	
	#return 
	return $username;
}

#return a username from passed id
sub get_username_from_id
{
	#get parameters
	my ($id) = @_;
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select username from users where id = ?}) or die $dbh->errstr;
	
	#execute it
	$sth->execute($id) or die $dbh->errstr;
	
	#save the resulting username
	my ($username) = $sth->fetchrow_array();
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
	
	#return 
	return $username;
}

#return a username from passed session id
sub get_userid_from_sid
{
	#get parameters
	my ($sid) = @_;
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select id from users where sid = ?}) or die $dbh->errstr;
	
	#execute it
	$sth->execute($sid) or die $dbh->errstr;
	
	#save the resulting username
	my ($username) = $sth->fetchrow_array();
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
	
	#return 
	return $username;
}
