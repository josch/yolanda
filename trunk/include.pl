#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Session;
use DBI;
use XML::Simple qw(:strict);
use Digest::SHA qw(sha256_hex);
use LWPx::ParanoidAgent;
use Net::OpenID::Consumer;
use CGI::Carp qw(fatalsToBrowser set_message);

set_message("It's not a bug, it's a feature!!<br />(include this error message in your bugreport here: <a href=\"http://yolanda.mister-muffin.de/newticket\">Yolanda bugtracker</a>)");

# change this as you install it somewhere else
$root = '/var/www/yolanda';

use lib qw(/var/www/yolanda);

#set global variables
$database = 'yolanda';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$domain = 'http://localhost';
$session_name = 'sid';
$locale = "en-US";
$stylesheet = "/style/default.css";
$xmlns_dc = "http://purl.org/dc/elements/1.1/";
$xmlns_cc = "http://web.resource.org/cc/";
$xmlns_rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
$defaultpagesize = 20;
$maxpagesize = 500;
$dbh = DBI->connect("DBI:mysql:$database:$dbhost", $dbuser, $dbpass);
1;
