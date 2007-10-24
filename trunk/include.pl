#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Session;
use DBI;
use XML::Simple qw(:strict);
use Digest::SHA qw(sha256_hex);
use Encode qw(decode_utf8);

# change this as you install it somewhere else
$gnutube_root = '/var/www/gnutube';

use lib qw(/var/www/gnutube);

#set global variables
$database = 'gnutube';
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = '';
$domain = 'http://localhost';
$session_name = 'sid';
$XMLDecl = qq{<?xml version="1.0" encoding="UTF-8" ?><?xml-stylesheet type="text/xsl" href="/xsl/xhtml.xsl" ?>};
$locale = "en-US";
$stylesheet = "/style/gnutube.css";
$xmlns_dc = "http://purl.org/dc/elements/1.1/";
$xmlns_cc = "http://web.resource.org/cc/";
$xmlns_rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";

1;
