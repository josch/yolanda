<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://a9.com/-/spec/opensearch/1.1/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:output
	encoding="utf8"
	indent="yes"
	method="xml"
	media-type="application/xml"
	omit-xml-declaration="no"
/>

<xsl:variable name="locale">
	<xsl:choose>
		<xsl:when test="document(concat('../locale/', //@locale, '.xml'))">
			<xsl:value-of select="//@locale" />
		</xsl:when>
		<xsl:otherwise>en-us</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="site_strings" select="document('../site/main.xml')//strings/string" />
<xsl:variable name="locale_strings" select="document(concat('../locale/', $locale, '.xml'))//strings/string" />

<!-- kill xml, opensearch is the same everywhere -->
<xsl:template match="/">
	<OpenSearchDescription>

		<Description>
			<xsl:value-of select="$site_strings[@id='site_motto']" />
		</Description>

		<Image
			height="16"
			width="16"
			type="image/x-icon"
		>
			<xsl:value-of select="$site_strings[@id='page_root']" />images/favicon.ico
		</Image>

		<Query
			role="example"
			searchTerms="example"
		/>

		<ShortName>
			<xsl:value-of select="$site_strings[@id='site_name']" />
		</ShortName>

		<Url type="text/html">
			<xsl:attribute name="template">
				<xsl:value-of select="$site_strings[@id='page_root']" />/search.pl?query={searchTerms}
			</xsl:attribute>
		</Url>

	</OpenSearchDescription>
</xsl:template>

</xsl:stylesheet>
