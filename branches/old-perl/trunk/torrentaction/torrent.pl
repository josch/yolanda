$database = 'yolanda';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$root = '/var/www/yolanda';


use Digest::SHA qw{sha1};

open(FILE, "<$root/videos/1");
while (my $BytesRead = read (FILE, $buff, 262144))
{
	$hash .= sha1($buff);
}
close(FILE);

%torrent = (
	'announce'		=> 'http://my.tracker.tld/announce',
	'announce-list'	=>
	[
		[
			'tracker1'
		]
	],
	'creation date'	=> 2342134213,
	'comment'		=> 'kommentar',
	'created by'	=> 'yolanda',
	'httpseeds'		=>
	[
		'mydomain.tld/seed'
	],
	'info' =>
	{
		'length'		=> -s "$root/videos/1",
		'name'			=> 'some name',
		'piece length'	=> 262144,
		'pieces'		=> $hash
	}
);

open(TORRENT, ">$root/1.torrent");
print TORRENT bencode(\%torrent);
close(TORRENT);
		
sub bencode {
	no locale;
	my $item = shift;
	my $line = '';
	
	if(ref($item) eq 'HASH')
	{
		$line = 'd';
		foreach my $key (sort(keys %{$item}))
		{
			$line .= bencode($key);
			$line .= bencode(${$item}{$key});
		}
		$line .= 'e';
	}
	elsif(ref($item) eq 'ARRAY')
	{
		$line = 'l';
		foreach my $l (@{$item})
		{
			$line .= bencode($l);
		}
		$line .= 'e';
	}
	elsif($item =~ /^\d+$/)
	{
		$line = 'i';
		$line .= $item;
		$line .= 'e';
	}
	else
	{
		$line = length($item).":";
		$line .= $item;
	}
	return $line;
}
