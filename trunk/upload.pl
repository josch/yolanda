require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
$query = new CGI;
my $session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

if($userinfo->{'username'})
{
	if($query->param('2'))
	{
		if($query->param('DC.Title')&&$query->param('DC.Subject')&&$query->param('DC.Description'))
		{
			$page->{'innerresults'} = [''];
	
			my @args = ();

			#build mysql query
			$dbquery = "select v.id, v.title, v.description, u.username,
				from_unixtime( v.timestamp ), v.creator, v.subject,
				v.contributor, v.source, v.language, v.coverage, v.rights,
				v.license, filesize, duration, width, height, fps, viewcount,
				downloadcount,
				match(v.title, v.description, v.subject)
				against( ? in boolean mode) as relevance
				from videos as v, users as u where u.id = v.userid
				and match(v.title, v.description, v.subject)
				against( ? in boolean mode)";
			push @args, $query->param('DC.Title'), $query->param('DC.Title');
	
			fill_results(@args);
			$page->{'uploadform'}->{'page'} = '2';
		}
		else
		{
			if(!$query->param('DC.Title'))
			{
				$page->{'message'}->{'type'} = "error";
				$page->{'message'}->{'text'} = "error_missing_DC.Title";
			}
			elsif(!$query->param('DC.Subject'))
			{
				$page->{'message'}->{'type'} = "error";
				$page->{'message'}->{'text'} = "error_missing_DC.Subject";
			}
			elsif(!$query->param('DC.Description'))
			{
				$page->{'message'}->{'type'} = "error";
				$page->{'message'}->{'text'} = "error_missing_DC.Description";
			}
			$page->{'uploadform'}->{'page'} = '1';
		}
	}
	elsif($query->param('3'))
	{
		$page->{'uploadform'}->{'page'} = '3';
	}
	elsif($query->param('4'))
	{
		$page->{'uploadform'}->{'page'} = '4';
	}
	elsif($query->param('5'))
	{
		$page->{'uploadform'}->{'page'} = '5';
	}
	elsif($query->param('6'))
	{
		$page->{'uploadform'}->{'page'} = '6';
	}
	else
	{
		$page->{'uploadform'}->{'page'} = '1';
	}
	$page->{'uploadform'}->{'DC.Title'} = $query->param('DC.Title');
	$page->{'uploadform'}->{'DC.Subject'} = $query->param('DC.Subject');
	$page->{'uploadform'}->{'DC.Description'} = $query->param('DC.Description');
	$page->{'uploadform'}->{'DC.Creator'} = $query->param('DC.Creator');
	$page->{'uploadform'}->{'DC.Source'} = $query->param('DC.Source');
	$page->{'uploadform'}->{'DC.Language'} = $query->param('DC.Language');
	$page->{'uploadform'}->{'DC.Coverage'} = $query->param('DC.Coverage');
}
else
{
	$page->{'message'}->{'type'} = "error";
	$page->{'message'}->{'text'} = "error_202c";
}

print output_page();
