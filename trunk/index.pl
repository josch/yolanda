require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
$query = new CGI;
my $session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

$page->{frontpage} = [''];	

if($query->param('information'))
{
	
	$page->{'message'}->{'type'} = "information";
	$page->{'message'}->{'text'} = $query->param('information');
}
elsif($query->param('error'))
{
	
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = $query->param('error');
}


#prepare query
my $sth = $dbh->prepare(qq{select text, count from tagcloud }) or die $dbh->errstr;

#execute it
$sth->execute() or die $dbh->errstr;

#get every returned value
while (my ($text, $count) = $sth->fetchrow_array())
{
	#push the new value to the $page->tagcloud array
	push @{ $page->{tagcloud}->{tag} }, { text => [$text =~ / / ? "\"$text\"" : $text], count => [$count] };
}

#finish query
$sth->finish() or die $dbh->errstr;

#close db
$dbh->disconnect() or die $dbh->errstr;

#print xml http header along with session cookie
print $session->header(-type=>'text/xml', -charset=>'UTF-8');

#print xml
print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => '1');
