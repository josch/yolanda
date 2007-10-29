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

sub get_userinfo_from_sid
{
	#get parameters
	my ($sid) = @_;
	
	#connect to db
	my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
	#prepare query
	my $sth = $dbh->prepare(qq{select id, username, locale, pagesize, cortado from users where sid = ?}) or die $dbh->errstr;
	
	#execute it
	$sth->execute($sid) or die $dbh->errstr;
	
	#save the resulting username
	($userinfo->{'id'}, $userinfo->{'username'}, $userinfo->{'locale'}, $userinfo->{'pagesize'}, $userinfo->{'cortado'}) = $sth->fetchrow_array();
	
	#finish query
	$sth->finish() or die $dbh->errstr;
	
	#close db
	$dbh->disconnect() or die $dbh->errstr;
	
	#return 
	return @userinfo;
}

sub get_page_array
{
	#get parameters
	my (@userinfo) = @_;
	
	$page->{'username'} = $userinfo->{'username'};
	#if user is logged in, use his locale setting
	if($userinfo->{'locale'})
	{
		$page->{'locale'} = $userinfo->{'locale'};
	}
	#else get the locale from the http server variable
	else
	{
		($page->{'locale'}) = $query->http('HTTP_ACCEPT_LANGUAGE') =~ /^([^,]+),.*$/;
	}
	$page->{stylesheet} = $stylesheet;
	$page->{'xmlns:dc'} = $xmlns_dc;
	$page->{'xmlns:cc'} = $xmlns_cc;
	$page->{'xmlns:rdf'} = $xmlns_rdf;
}
