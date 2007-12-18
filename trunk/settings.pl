require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

if($userinfo->{'username'})
{
	if($query->param('submit'))
	{
		$dbh->do(qq{update users set locale = ?, pagesize = ?, cortado = ? where id = ?}, undef, $query->param('locale'), $query->param('pagesize'), $query->param('cortado'), $userinfo->{'id'} ) or die $dbh->errstr;
	}
}

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);
	
if($userinfo->{'username'})
{
	$page->{'account'}->{'show'} = 'settings';
	$page->{'account'}->{'locale'} = $userinfo->{'locale'};
	$page->{'account'}->{'pagesize'} = $userinfo->{'pagesize'};
	$page->{'account'}->{'cortado'} = $userinfo->{'cortado'}
}
else
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
}

print output_page();
