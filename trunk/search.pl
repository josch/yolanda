require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

#check if query is set
if($query->param('query') or $query->param('orderby'))
{
	#TODO: clean up scriptname, argument, value only being there because of
	#TODO: account.pl also calling fill_results() which will be changed
	$page->{'search'} = [''];
	$page->{'results'}->{'scriptname'} = 'search.pl';
	$page->{'results'}->{'argument'} = 'query';
	$page->{'results'}->{'value'} = $query->param('query');
	$page->{'results'}->{'orderby'} = $query->param('orderby');
	$page->{'results'}->{'sort'} = $query->param('sort');
	
	my @args = ();
	
	$strquery = $query->param('query');
	(@tags) = $strquery =~ /tag:(\w+)/gi;
	($username) = $strquery =~ /user:(\w+)/i;
	$strquery =~ s/(tag|title|user):\w+//gi;
	$strquery =~ s/^\s*(.*?)\s*$/$1/;

	#build mysql query
	$dbquery = "select v.id, v.title, v.description, u.username,
		from_unixtime( v.timestamp ), v.creator, v.subject, v.contributor,
		v.source, v.language, v.coverage, v.rights, v.license, filesize,
		duration, width, height, fps, viewcount, downloadcount, 1";
	
	if($strquery)
	{
		$dbquery .= ", match(v.title, v.description, v.subject) against( ? in boolean mode) as relevance";
		$dbquery .= " from videos as v, users as u where u.id = v.userid";
		$dbquery .= " and match(v.title, v.description, v.subject) against( ? in boolean mode)";
		push @args, $strquery, $strquery;
	}
	else
	{
		$dbquery .= " from videos as v, users as u where u.id = v.userid";
	}
	
	if(@tags)
	{
		$dbquery .= " and match(v.subject) against (? in boolean mode)";
		push @args, "@tags";
	}
	
	if($username)
	{
		$dbquery .= " and match(u.username) against (? in boolean mode)";
		push @args, "$username";
	}
	
	if($query->param('orderby'))
	{
		if($query->param('orderby') eq 'filesize')
		{
			$dbquery .= " order by v.filesize";
		}
		elsif($query->param('orderby') eq 'duration')
		{
			$dbquery .= " order by v.duration";
		}
		elsif($query->param('orderby') eq 'viewcount')
		{
			$dbquery .= " order by v.viewcount";
		}
		elsif($query->param('orderby') eq 'downloadcount')
		{
			$dbquery .= " order by v.downloadcount";
		}
		elsif($query->param('orderby') eq 'timestamp')
		{
			$dbquery .= " order by v.timestamp";
		}
		elsif($query->param('orderby') eq 'relevance' and $query->param('query'))
		{
			$dbquery .= " order by relevance";
		}
		else
		{
			$dbquery .= " order by v.id";
		}
		
		if($query->param('sort') eq "asc")
		{
			$dbquery .= " asc"
		}
		else
		{
			$dbquery .= " desc"
		}
	}
	
	fill_results(@args);
}
else
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
}

print output_page();
