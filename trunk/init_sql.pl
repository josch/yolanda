#!/usr/bin/perl
require "include.pl";

#create or resume session
CGI::Session->name($session_name);
my $session = new CGI::Session;

my $dbh = DBI->connect("DBI:mysql:$database:$host", $dbuser, $dbpass) or die $dbh->errstr;

$dbh->do(qq{drop table users});

$dbh->do(qq{drop table videos});

$dbh->do(qq{drop table tagcloud});

$dbh->do(qq{create table
	tagcloud
	(
		text		varchar(255)		not null,
		count		int					not null
	)
});

$dbh->do(qq{insert into
	tagcloud values
	(
	'web tv', 68
	)
});

$dbh->do(qq{create table
	users
	(
		id			int auto_increment	not null,
		username	varchar(255)		not null,
		password	char(41)			not null,
		sid			char(32)			not null,
		primary key	(id)
	)
});

$dbh->do(qq{create table
	videos
	(
		id			int auto_increment	not null,
		title		varchar(255)		not null,
		caption		text				not null,
		userid		int					not null,
		hash		char(64)			not null,
		status		int					not null,
		timestamp	datetime			not null,
		filesize	int					not null,
		duration	float				not null,
		width		smallint			not null,
		height		smallint			not null,
		fps			float				not null,
		primary key	(id),
		fulltext	(title, caption)
	)
});

$dbh->disconnect() or die $dbh->errstr;

print $session->header();
print "initiated database";
