#!/usr/bin/perl -w

#TODO: make this script specific when we use fastcgi
use CGI qw(:standard);
use CGI::Session;
use DBI;
use XML::Simple qw(:strict);
use Digest::SHA qw(sha256_hex);
use LWPx::ParanoidAgent;
use Net::OpenID::Consumer;
use File::Copy;
use XML::LibXSLT;
use XML::LibXML;
use LWP::UserAgent;
use HTTP::Request;
use CGI::Carp qw(fatalsToBrowser set_message);

#send error message to user
set_message("It's not a bug, it's a feature!!<br />(include this error message in your bugreport here: <a href=\"http://yolanda.mister-muffin.de/newticket\">Yolanda bugtracker</a>)");

# change this as you install it somewhere else
$root = '/var/www/yolanda';

use lib qw(/var/www/yolanda);

#set global config variable
$config = XMLin("$root/config/backend.xml", KeyAttr => {string => 'id'}, ForceArray => [ 'string' ], ContentKey => '-content');
$config = $config->{"strings"}->{"string"};

#set database connection string
$dbh = DBI->connect("DBI:mysql:".$config->{"database_name"}.":".$config->{"database_host"}, $config->{"database_username"}, $config->{"database_password"}) or die $DBI::errstr;
1;
