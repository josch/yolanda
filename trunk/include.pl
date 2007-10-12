#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Session;
use DBI;
use XML::Simple qw(:strict);
use Digest::SHA qw(sha256_hex);
use Encode qw(decode_utf8);

$gnutube_root = '/var/www/gnutube';

use lib qw(/var/www/gnutube);

#set global variables
$database = 'gnutube';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$session_name = 'sid';
$XMLDecl = '<?xml version="1.0" encoding="UTF-8" ?><?xml-stylesheet type="text/xsl" href="./xsl/xhtml.xsl" ?>';
$locale = "en-US";
$stylesheet = "./style/gnutube.css";

1;
