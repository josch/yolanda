#!/usr/bin/perl -w

use DBI;
use XML::Simple qw(:strict);

$root = '/var/www/yolanda';

#set global config variable
$config = XMLin("$root/config/backend.xml", KeyAttr => {string => 'id'}, ForceArray => [ 'string' ], ContentKey => '-content');
$config = $config->{"strings"}->{"string"};

$dbh = DBI->connect("DBI:mysql:".$config->{"database_name"}.":".$config->{"database_host"}, $config->{"database_username"}, $config->{"database_password"}) or die $DBI::errstr;

$sth = $dbh->prepare("select subject from videos");
$sth->execute();
#cycle through all video subjects
while(($subject) = $sth->fetchrow_array())
{
    @subject = split(' ', $subject);
    #cycle through all tags of video
    foreach my $val (@subject)
    {
        #strip whitespaces
        $val =~ s/^\s*(.*?)\s*$/$1/;
        if(length($val) >= $config->{"page_tag_lenght_min"})
        {
            %hash->{$val}++;
        }
    }
}
$sth->finish();

#sort by count
@sorted = sort {$hash{$b} cmp $hash{$a}} keys %hash;

$dbh->do("delete from tagcloud");
$sth = $dbh->prepare("insert into tagcloud (text, count) values (?, ?)");
#insert  tags into tagcloud table
for($i=0;$i<$config->{"page_tag_count"} and $i<=$#sorted;$i++)
{
    $sth->execute( $sorted[$i], %hash->{$sorted[$i]} );
}
