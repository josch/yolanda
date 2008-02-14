require "functions.pl";

#create or resume session
CGI::Session->name($session_name);
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

@page = get_page_array(@userinfo);

if($userinfo->{'username'})
{
    $page->{'uploadform'}->{'DC.Title'} = $query->param('DC.Title');
    $page->{'uploadform'}->{'DC.Subject'} = $query->param('DC.Subject');
    $page->{'uploadform'}->{'DC.Description'} = $query->param('DC.Description');
    $page->{'uploadform'}->{'DC.Creator'} = $query->param('DC.Creator');
    $page->{'uploadform'}->{'DC.Source'} = $query->param('DC.Source');
    $page->{'uploadform'}->{'DC.Language'} = $query->param('DC.Language');
    $page->{'uploadform'}->{'DC.Coverage'} = $query->param('DC.Coverage');
    $page->{'uploadform'}->{'DC.Rights'} = $query->param('DC.Rights');
    $page->{'uploadform'}->{'DC.License'} = $query->param('DC.License');
    
    if($query->param('2'))
    {
        if($query->param('DC.Title')&&$query->param('DC.Subject')&&$query->param('DC.Description'))
        {
            $page->{'innerresults'} = [''];
    
            my @args = ();

            #build mysql query
            $dbquery = "select v.id, v.title, v.description, u.username,
                from_unixtime( v.timestamp ), v.creator, v.subject,
                v.source, v.language, v.coverage, v.rights,
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
        if($query->param('DC.License') eq 'cc-by')
        {
            $page->{'uploadform'}->{'remix'} = 'true';
        }
        elsif($query->param('DC.License') eq 'cc-by-sa')
        {
            $page->{'uploadform'}->{'sharealike'} = 'true';
        }
        elsif($query->param('DC.License') eq 'cc-by-nd')
        {
            $page->{'uploadform'}->{'noderivatives'} = 'true';
        }
        elsif($query->param('DC.License') eq 'cc-by-nc')
        {
            $page->{'uploadform'}->{'remix'} = 'true';
            $page->{'uploadform'}->{'noncommercial'} = 'true';
        }
        elsif($query->param('DC.License') eq 'cc-by-nc-sa')
        {
            $page->{'uploadform'}->{'sharealike'} = 'true';
            $page->{'uploadform'}->{'noncommercial'} = 'true';
        }
        elsif($query->param('DC.License') eq 'cc-by-nc-nd')
        {
            $page->{'uploadform'}->{'noderivatives'} = 'true';
            $page->{'uploadform'}->{'noncommercial'} = 'true';
        }
        
        $page->{'uploadform'}->{'page'} = '4';
    }
    elsif($query->param('5'))
    {
        if($query->param('modification') and not $query->param('DC.License'))
        {
            if($query->param('modification') eq 'remix')
            {
                if($query->param('noncommercial'))
                {
                    $page->{'uploadform'}->{'DC.License'} = 'cc-by-nc';
                }
                else
                {
                    $page->{'uploadform'}->{'DC.License'} = 'cc-by';    
                }
            }
            elsif($query->param('modification') eq 'sharealike')
            {
                if($query->param('noncommercial'))
                {
                    $page->{'uploadform'}->{'DC.License'} = 'cc-by-nc-sa';
                }
                else
                {
                    $page->{'uploadform'}->{'DC.License'} = 'cc-by-sa';
                }
            }
            elsif($query->param('modification') eq 'noderivatives')
            {
                if($query->param('noncommercial'))
                {
                    $page->{'uploadform'}->{'DC.License'} = 'cc-by-nc-nd';
                }
                else
                {
                    $page->{'uploadform'}->{'DC.License'} = 'cc-by-nd';
                }
            }
        }
        
        $page->{'uploadform'}->{'page'} = '5';
    }
    else
    {
        $page->{'uploadform'}->{'page'} = '1';
    }
}
else
{
    $page->{'message'}->{'type'} = "error";
    $page->{'message'}->{'text'} = "error_202c";
}

print output_page();
