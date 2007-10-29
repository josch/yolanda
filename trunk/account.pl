#!/usr/bin/perl
require "include.pl";
require "functions.pl";

#initialize session data
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);
	
if($userinfo->{'username'})
{
	if($query->param('show') eq 'settings')
	{
		#results per page
		#language
		#cortado or plugin
	}
	elsif($query->param('show') eq 'uploads')
	{
		$page->{'results'}->{'scriptname'} = 'account.pl';
		$page->{'results'}->{'argument'} = 'show';
		$page->{'results'}->{'value'} = 'uploads';
		$page->{'results'}->{'orderby'} = $query->param('orderby');
		$page->{'results'}->{'sort'} = $query->param('sort');
	
		#connect to db
		my $dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass) or die $dbh->errstr;
	
		#build mysql query
		$dbquery = "(select v.id, v.title, u.username, from_unixtime( v.timestamp ) as timestamp, v.duration, v.viewcount
					from videos as v, users as u where v.userid = u.id and u.sid = ?)
					union
					(select v.id, v.title, u.username, from_unixtime( v.timestamp ) as timestamp, 0, 0
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
	
		#prepare query
		my $sth = $dbh->prepare($dbquery) or die $dbh->errstr;
	
		#execute it
		$resultcount = $sth->execute($session->id, $session->id) or die $dbh->errstr;
	
		$pagesize = 2;
	
		#rediculous but funny round up, will fail with 100000000000000 results per page
		#on 0.0000000000001% of all queries - this is a risk we can handle
		$lastpage = int($resultcount/$pagesize+0.99999999999999);
	
		$currentpage = $query->param('page') or $currentpage = 1;
	
		$dbquery .= " limit ".($currentpage-1)*$pagesize.", ".$pagesize;
	
		#prepare query
		$sth = $dbh->prepare($dbquery) or die $dbh->errstr;
	
		#execute it
		$sth->execute($session->id, $session->id) or die $dbquery;
	
		$page->{'results'}->{'lastpage'} = $lastpage;
		$page->{'results'}->{'currentpage'} = $currentpage;
		$page->{'results'}->{'resultcount'} = $resultcount;
		$page->{'results'}->{'pagesize'} = $pagesize;
	
		#get every returned value
		while (my ($id, $title, $publisher, $timestamp, $duration, $viewcount) = $sth->fetchrow_array())
		{
			#before code cleanup, this was a really obfuscated array/hash creation
			push @{ $page->{'results'}->{'result'} },
			{
				'thumbnail'		=> $duration == 0 ? "/images/tango/video-x-generic.png" : "/video-stills/$id",
				'duration'		=> $duration,
				'viewcount'		=> $viewcount,
				'edit'			=> $userinfo->{'username'} eq $publisher ? "true" : "false",
				'rdf:RDF'		=>
				{
					'cc:Work'		=>
					{
						'dc:title'			=> [$title],
						'dc:date'			=> [$timestamp],
						'dc:identifier'		=> ["$domain/video/$title/$id" . ($duration == 0 ? "/edit=true" : "") ],
						'dc:publisher'		=> [$publisher]
					},
					'cc:License'	=>
					{
						'rdf:about' 	=> 'http://creativecommons.org/licenses/GPL/2.0/'
					}
				}
			};
		}
	
		#finish query
		$sth->finish() or die $dbh->errstr;
	
		#close db
		$dbh->disconnect() or die $dbh->errstr;
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
