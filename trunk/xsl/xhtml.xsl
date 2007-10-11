<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

IRGENDWAS DUMMES WAS DA NICHT INGEHÖRT

<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.1//EN"
	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
	encoding="us-ascii"
	indent="yes"
	method="xml"
	media-type="application/xhtml+xml"
	omit-xml-declaration="no"
/>

<xsl:variable name="site_strings" select="document('../site/gnutube.xml')//strings" />
<xsl:variable name="locale_strings" select="document(concat('../locale/',/page/@locale,'.xml'))//strings" />

<xsl:variable name="resultspage">search.pl?query=</xsl:variable>

<xsl:template match="/">
	<html xmlns="http://www.w3.org/1999/xhtml">

		<head>
			<meta http-equiv="Content-Type" content="application/xhtml+xml" />
			<link rel="shortcut icon" type="image/x-icon" href="./images/favicon.ico" />
			<link rel="stylesheet" type="text/css">
				<xsl:attribute name="href">
					<xsl:value-of select="//@stylesheet" />
				</xsl:attribute>
			</link>
			<title>
				<xsl:choose>
					<xsl:when test="boolean(//frontpage)">
						<xsl:value-of select="$site_strings/str[@id='site_name']" />
						-
						<xsl:value-of select="$site_strings/str[@id='site_motto']" />
					</xsl:when>
					<xsl:when test="boolean(//resultspage)">
						<xsl:value-of select="$site_strings/str[@id='site_name']" />
						-
						<xsl:value-of select="$locale_strings/str[@id='results_for_query']" />
						"<xsl:value-of select="//resultspage/@query" />"
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$site_strings/str[@id='site_name']" />
						-
						<xsl:value-of select="$site_strings/str[@id='site_motto']" />
					</xsl:otherwise>
				</xsl:choose>
			</title>
		</head>

		<body>

			<xsl:choose>
				<xsl:when test="string-length(//@username)=0">
					<div class="header1">
						<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='login_to_upload']" /></a>
					</div>
					<div class="header2">
						<a href="register.pl"><xsl:value-of select="$locale_strings/str[@id='register']" /></a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<a href="login.pl"><xsl:value-of select="$locale_strings/str[@id='login']" /></a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<img class="openid-icon" src="./images/openid-icon.png" alt="open id logo" />
						<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='login_openid']" /></a>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="header1">
						<a href="upload.pl"><xsl:value-of select="$locale_strings/str[@id='upload_video']" /></a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='bookmarks']" /></a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='account_details']" /></a>
					</div>
					<div class="header2">
						<xsl:value-of select="$locale_strings/str[@id='logged_in_as']" />
						<a>
							<xsl:attribute name="href">
								user/<xsl:value-of select="//@username" />
							</xsl:attribute>
							<xsl:value-of select="//@username" />
						</a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<a href="login.pl?action=logout"><xsl:value-of select="$locale_strings/str[@id='logout']" /></a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<hr />
	
			<xsl:apply-templates />

			<div class="footer">
				<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='gnutube_authors']" /></a>
				<xsl:value-of select="$locale_strings/str[@id='separator']" />
				<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='gnutube_license']" /></a>
				<xsl:value-of select="$locale_strings/str[@id='separator']" />
				<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='gnutube_source_code']" /></a>
			</div>

		</body>

	</html>
</xsl:template>

<xsl:template match="frontpage">

	<div class="logo-big">
		<img src="./images/logo-big.png" alt="GNUtube logo (320x100)" />
	</div>

	<div class="search">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$resultspage" />
			</xsl:attribute>
			<fieldset>
				<input type="text" name="query" size="40" /><br />
				<input type="submit">
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings/str[@id='button_find']" />
					</xsl:attribute>
				</input>&#160;
				<input type="submit" name="lucky">
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings/str[@id='button_lucky']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
	</div>

	<div class="toplists">
		<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='query_latestadditions']" /></a>
		<xsl:value-of select="$locale_strings/str[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='query_mostdownloads']" /></a>
		<xsl:value-of select="$locale_strings/str[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='query_bestrated']" /></a>
	</div>

</xsl:template>

<xsl:template match="searchbar">

	<div class="logo-small-top">
		<img src="./images/logo-small-top.png" alt="GNUtube logo top (160x25)" />
	</div>

	<div class="search-small">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$resultspage" />
			</xsl:attribute>
			<fieldset>
				<xsl:value-of select="$locale_strings/str[@id='search']" />
				<input type="text" name="query" size="auto" />
			</fieldset>
		</form>
	</div>

	<div class="logo-small-bottom">
		<img src="./images/logo-small-bottom.png" alt="GNUtube logo top (160x25)" />
	</div>

</xsl:template>

<xsl:template match="tagcloud">

	<div class="tagcloud">
		<xsl:for-each select="tag">
			<xsl:sort select="text" order="ascending" data-type="text" />
			<a class="tag">
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="count &gt;= 64">font-size:32px</xsl:when>
						<xsl:when test="count &lt;= 28">font-size:14px</xsl:when>
						<xsl:otherwise>
							font-size:<xsl:value-of select="round(number(count)div 2)" />px
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="href">
					<xsl:value-of select="$resultspage" />tag:<xsl:value-of select="text" />
				</xsl:attribute>
				<xsl:value-of select="text" />
				(<xsl:value-of select="count" />)
			</a>
		</xsl:for-each>
	</div>

</xsl:template>

<xsl:template match="results">

	<div>
		THE SEARCH FOR
		"<xsl:value-of select="@query" />"
		BROUGHT US TEH FOLLOWING <del>OBJECTIONS</del><ins>OBJECTS</ins>.
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
					<xsl:value-of select="$locale_strings/str[@id='title']" />:<xsl:value-of select="rdf:RDF/cc:Work/dc:title" /><br />
					created by: <xsl:value-of select="rdf:RDF/cc:Work/dc:creator" /><br />
					uploaded by: <xsl:value-of select="rdf:RDF/cc:Work/dc:publisher" />
				</td>
			</tr>
		</xsl:for-each>
	</table>

</xsl:template>

<xsl:template match="registerform">

	<div class="registerform">

		<form action="" method="post">
			<fieldset>
				<input name="user" type="text" size="30" maxlength="30" />
				<input name="pass" type="password" size="30" maxlength="30" />
				<input type="submit" name="register" value=" register " />
			</fieldset>
		</form>

	<div>

</xsl:template>

</xsl:stylesheet>
