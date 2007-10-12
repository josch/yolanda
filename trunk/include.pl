#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Session;
use DBI;
use XML::Simple qw(:strict);
use Digest::SHA;
use Encode;

$gnutube_root = '/var/www/gnutube';

use lib qw(/var/www/gnutube);
#use Digest::SHA qw(sha256_hex);

#set global variables
$database = 'gnutube';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$session_name = 'sid';
$XMLDecl = '<?xml version="1.0" encoding="UTF-8" ?><?xml-stylesheet type="text/xsl" href="./xsl/xhtml.xsl" ?>';
1;
