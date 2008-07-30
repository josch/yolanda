require "functions.pl";

#create or resume session
CGI::Session->name($config->{"page_cookie_name"});
$query = new CGI;
$session = new CGI::Session;

@userinfo = get_userinfo_from_sid($session->id);

my $doc = XML::LibXML::Document->new( "1.0", "UTF-8" );

my $page = get_page_array(@userinfo);

$page->setNamespace( $config->{"xml_namespace_xforms"}, "xforms", 0);
$page->setNamespace( $config->{"xml_namespace_xsd"}, "xsd", 0);
$page->setNamespace( $config->{"xml_namespace_xsi"}, "xsi", 0);
$page->setNamespace( $config->{"xml_namespace_dcterms"}, "dcterms", 0 );

my $instance = XML::LibXML::Element->new( "instance" );
$instance->setNamespace( $config->{"xml_namespace_xforms"}, "xforms");

my $video = XML::LibXML::Element->new( "video" );

sub getElementDC
{
    my $node = XML::LibXML::Element->new( shift );
    $node->setNamespace( $config->{"xml_namespace_dcterms"}, "dcterms" );
    $node->setNamespace( $config->{"xml_namespace_xsi"}, "xsi", 0 );
    $node->setAttributeNS( $config->{"xml_namespace_xsi"}, "type", shift );
    return $node;
}

$video->appendChild( getElementDC( "title", "xsd:normalizedString") );
$video->appendChild( getElementDC( "alternative", "xsd:normalizedString") );
$video->appendChild( getElementDC( "abstract", "xsd:string") );
$video->appendChild( getElementDC( "spatial", "xsd:normalizedString") );
$video->appendChild( getElementDC( "subject", "xsd:normalizedString") );
$video->appendChild( getElementDC( "temporal", "xsd:date") );
$video->appendChild( getElementDC( "language", "xsd:language") );

$video->appendChild( getElementDC( "creator", "xsd:normalizedString") );
$video->appendChild( getElementDC( "contributor", "xsd:normalizedString") );
$video->appendChild( getElementDC( "created", "xsd:date") );

$video->appendChild( getElementDC( "hasFormat", "xsd:normalizedString") );
$video->appendChild( getElementDC( "hasPart", "xsd:normalizedString") );
$video->appendChild( getElementDC( "isFormatOf", "xsd:normalizedString") );
$video->appendChild( getElementDC( "isPartOf", "xsd:normalizedString") );
$video->appendChild( getElementDC( "references", "xsd:normalizedString") );
$video->appendChild( getElementDC( "replaces", "xsd:normalizedString") );

$video->appendChild( getElementDC( "rightsHolder", "xsd:normalizedString") );
$video->appendChild( getElementDC( "source", "xsd:normalizedString") );
$video->appendChild( getElementDC( "license", "xsd:normalizedString") );

$node = XML::LibXML::Element->new( "data" );
$node->setNamespace( $config->{"xml_namespace_xsi"}, "xsi", 0 );
$node->setAttributeNS( $config->{"xml_namespace_xsi"}, "type", "xsd:base64Binary" );
$video->appendChild( $node );

$instance->appendChild($video);

$page->appendChild($instance);

$doc->setDocumentElement($page);

output_page($doc);
