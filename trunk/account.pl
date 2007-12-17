require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

if($userinfo->{'username'})
{
	if($query->param('show') eq 'settings' and $query->param('submit'))
	{
		$dbh->do(qq{update users set locale = ?, pagesize = ?, cortado = ? where id = ?}, undef, $query->param('locale'), $query->param('pagesize'), $query->param('cortado'), $userinfo->{'id'} ) or die $dbh->errstr;
	}
}

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);
	
if($userinfo->{'username'})
{
	if($query->param('show') eq 'settings')
	{
		$page->{'account'}->{'show'} = 'settings';
		$page->{'account'}->{'locale'} = $userinfo->{'locale'};
		$page->{'account'}->{'pagesize'} = $userinfo->{'pagesize'};
		$page->{'account'}->{'cortado'} = $userinfo->{'cortado'}
	}
	elsif($query->param('show') eq 'bookmarks')
	{
		$page->{'account'}->{'show'} = 'bookmarks';
	}
	elsif($query->param('show') eq 'uploads')
	{
		$page->{'account'}->{'show'} = 'uploads';
		$page->{'results'}->{'scriptname'} = 'account.pl';
		$page->{'results'}->{'argument'} = 'show';
		$page->{'results'}->{'value'} = 'uploads';
		$page->{'results'}->{'orderby'} = $query->param('orderby');
		$page->{'results'}->{'sort'} = $query->param('sort');
	
		#build mysql query
		$dbquery = "(select v.id, v.title, v.description, u.username, from_unixtime( v.timestamp ) as timestamp,
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, filesize, duration, width, height, fps, viewcount, downloadcount, 1
					from videos as v, users as u where v.userid = u.id and u.sid = ?)
					union
					(select v.id, v.title, '', u.username, from_unixtime( v.timestamp ) as timestamp,
							v.creator, v.subject, v.contributor, v.source, v.language, v.coverage, v.rights,
							v.license, 0, 0, 0, 0, 0, 0, 0, v.status
					from uploaded as v, users as u where v.userid = u.id and u.sid = ?)";
	
		if($query->param('orderby'))
		{
			if($query->param('orderby') eq 'filesize')
			{
				$dbquery .= " order by filesize";
			}
			elsif($query->param('orderby') eq 'duration')
			{
				$dbquery .= " order by duration";
			}
			elsif($query->param('orderby') eq 'viewcount')
			{
				$dbquery .= " order by viewcount";
			}
			elsif($query->param('orderby') eq 'timestamp')
			{
				$dbquery .= " order by timestamp";
			}
			else
			{
				$dbquery .= " order by id";
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
	
		fill_results($session->id, $session->id);
	}
	else
	{
		$page->{'account'} = [''];
	}
}
else
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
}

#print xml http header along with session cookie
print $session->header(-type=>'text/xml', -charset=>'UTF-8');

#print xml
print XMLout($page, KeyAttr => {}, XMLDecl => $XMLDecl, RootName => 'page', AttrIndent => '1');
