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

my $node = XML::LibXML::Element->new( "abstract" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:string" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "alternative" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "contributor" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "created" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:date" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "creator" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "hasFormat" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "isFormatOf" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "isPartOf" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "language" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:language" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "license" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "references" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "replaces" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "rightsHolder" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "source" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "spatial" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "subject" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "temporal" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:date" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "title" );
$node->setNamespace( "http://purl.org/dc/terms/", "dcterms" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:normalizedString" );
$video->appendChild($node);

$node = XML::LibXML::Element->new( "data" );
$node->setNamespace( "http://www.w3.org/2001/XMLSchema-instance", "xsi", 0 );
$node->setAttributeNS( "http://www.w3.org/2001/XMLSchema-instance", "type", "xsd:base64Binary" );
$video->appendChild($node);

$instance->appendChild($video);

$page->appendChild($instance);

$doc->setDocumentElement($page);

output_page($doc);
