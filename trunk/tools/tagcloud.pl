#!/usr/bin/perl -w

use DBI;

$database = 'yolanda';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';

$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);

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
        if(length($val) >= 3)
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
#insert first 20 tags into tagcloud table
for($i=0;$i<20 and $i<=$#sorted;$i++)
{
    $sth->execute( $sorted[$i], %hash->{$sorted[$i]} );
}
