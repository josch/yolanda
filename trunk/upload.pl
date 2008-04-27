require "functions.pl";

#create or resume session
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

$page->setNamespace("http://www.w3.org/2002/xforms", "xforms", 0);
$page->setNamespace("http://www.w3.org/2001/XMLSchema", "xsd", 0);
$page->setNamespace("http://www.w3.org/2001/XMLSchema-instance", "xsi", 0);

my $instance = XML::LibXML::Element->new( "instance" );
$instance->setNamespace("http://www.w3.org/2002/xforms", "xforms");

my $video = XML::LibXML::Element->new( "video" );

my $node = XML::LibXML::Element->new( "Title" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "Subject" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "Description" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:string" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "Coverage.day" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:gDay" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "Coverage.month" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:gMonth" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "Coverage.year" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:gYear" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "Coverage.placeName" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "Language" );
$node->setNamespace( "http://purl.org/dc/elements/1.1/", "dc" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:language" );
$video->appendChild($node);

$instance->appendChild($video);

$page->appendChild($instance);

$doc->setDocumentElement($page);

output_page($doc);
