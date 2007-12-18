#!/usr/bin/perl

use LWP::UserAgent;
use HTTP::Request::Common;
use Getopt::Std;

sub preamble {
    print "yolanda-upload by Johannes Schauer (josch)\n";
    print "http://yolanda.mister-muffin.de/trac\n";
    print "\n"
}

# set these values for default -l (login) and -p (pass) values
#
use constant USER => "";
use constant PASS  => "";

# various urls
my $url  = 'http://localhost';

unless (@ARGV) {
    preamble();
    print "Usage: $0 ",
          "-u [username] ",
          "-p [password] ",
          "-f <video file> ",
          "-t <title> ",
          "-d <description> ",
          "-x <space separated tags>",
          "-c <creator>",
          "-s <source>",
          "-l <language>",
          "-v <coverage>\n\n";
    exit 1;
}

my %opts;
getopts('u:p:f:t:d:x:c:s:l:v:', \%opts);

unless (defined $opts{u}) {
    unless (length USER) {
        preamble();
		print "Username was neither defined nor passed as an argument\n";
        print "Use -u switch to specify the username\n";
        print "Example: -u joe_random\n";
        exit 1;
    }
    else {
        $opts{l} = USER;
    }
}

unless (defined $opts{p}) {
    unless (length PASS) {
        preamble();
        print "Password was neither defined nor passed as an argument\n";
        print "Use -p switch to specify the password\n";
        print "Example: -p secretPass\n";
        exit 1;
    }
    else {
        $opts{p} = PASS;
    }
}

unless (defined $opts{f} && length $opts{f}) {
    preamble();
    print "No video file was specified\n";
    print "Use -f switch to specify the video file\n";
    print 'Example: -f "C:\Program Files\movie.avi"', "\n";
    print 'Example: -f "/home/pkrumins/super.cool.video.wmv"', "\n";
    exit 1;
}

unless (-r $opts{f}) {
    preamble();
    print "Video file is not readable or does not exist\n";
    print "Check the permissions and the path to the file\n";
    exit 1;
}

unless (defined $opts{t} && length $opts{t}) {
    preamble();
    print "No video title was specified\n";
    print "Use -t switch to set the title of the video\n";
    print 'Example: -t "Super Cool Video Title"', "\n";
    exit 1;
}


$ua = LWP::UserAgent->new(cookie_jar => {});

push @{$ua->requests_redirectable}, 'POST';

print "Getting sid cookie...\n";
$response = $ua->request(GET $url);
unless($response->is_success)
{
	die "Failed opening $url: ",
		$response->status_line;
}

print "Logging in to $url/login.pl...\n";
$response = $ua->request(POST "$url/login.pl", "Content_Type" => "form-data", "Content" => [action => login, user => test, pass => test]);
unless($response->is_success)
{
	die "Failed logging in: ",
		$response->status_line;
}
unless($response->content =~ /action=logout/)
{
	die "Failed logging in: username/password do not match";
}

print "Uploading $opts{f} to $url/uploader.pl...\n";
$response = $ua->request(POST "$url/uploader.pl",
	"Content_Type" => "multipart/form-data",
	"Content" => [
		file => [$opts{f}],
		"DC.Title" => $opts{t},
		"DC.Description" => $opts{d},
		"DC.Subject" => $opts{x},
		"DC.Creator" => $opts{c} ? $opts{c} : "",
		"DC.Source" => $opts{s} ? $opts{s} : "",
		"DC.Language" => $opts{l} ? $opts{l} : "",
		"DC.Coverage" => $opts{v} ? $opts{v} : "",
	]
);
unless($response->is_success)
{
	die "Failed uploading: ",
		$response->status_line;
}
print "Done!\n";
