<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.1//EN"
	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
	encoding="utf8"
	indent="yes"
	method="xml"
	media-type="application/xhtml+xml"
	omit-xml-declaration="no"
/>

<xsl:template match="results">
	<xsl:call-template name="searchbar"/>
	<div>
		<xsl:value-of select="$locale_strings/str[@id='results_for_query']" />:
		"<xsl:value-of select="@query" />"
	</div>
	<table class="results">
		<xsl:for-each select="result">
			<tr class="result">
				<td>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
						</xsl:attribute>
						<img>
							<xsl:attribute name="src">
								<xsl:value-of select="thumbnail" />
							</xsl:attribute>
							<xsl:attribute name="alt">
								<xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
							</xsl:attribute>
						</img>
					</a>
				</td>
				<td>
					<xsl:value-of select="$locale_strings/str[@id='DC.title']" />: <xsl:value-of select="rdf:RDF/cc:Work/dc:title" /><br />
					<xsl:value-of select="$locale_strings/str[@id='DC.creator']" />: <xsl:value-of select="rdf:RDF/cc:Work/dc:creator" /><br />
					<xsl:value-of select="$locale_strings/str[@id='DC.publisher']" />: <xsl:value-of select="rdf:RDF/cc:Work/dc:publisher" />
				</td>
			</tr>
		</xsl:for-each>
	</table>

</xsl:template>