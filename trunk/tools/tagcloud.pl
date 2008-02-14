#!/usr/bin/perl -w

use DBI;

$database = 'yolanda';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';

$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);

$sth = $dbh->prepare("select subject from videos");
$sth->execute();
while(($subject) = $sth->fetchrow_array())
{
    @subject = split(' ', $subject);
    foreach my $val (@subject)
    {
        $val =~ s/^\s*(.*?)\s*$/$1/;
        if(length($val) >= 4)
        {
            %hash->{$val}++;
        }
    }
}
$sth->finish();

@sorted = sort {$hash{$b} cmp $hash{$a}} keys %hash;

$dbh->do("delete from tagcloud");
$sth = $dbh->prepare("insert into tagcloud (text, count) values (?, ?)");
for($i=0;$i<20 and $i<=$#sorted;$i++)
{
    $sth->execute( $sorted[$i], %hash->{$sorted[$i]} );
}
