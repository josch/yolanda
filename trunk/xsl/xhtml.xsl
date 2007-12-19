<?xml version="1.0" encoding="UTF-8" ?>
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
	encoding="UTF-8"
	indent="yes"
	method="xml"
	media-type="application/xhtml+xml"
	omit-xml-declaration="no"
/>

<xsl:include href="./xhtml/frontpage.xsl"/>
<xsl:include href="./xhtml/loginform.xsl"/>
<xsl:include href="./xhtml/results.xsl"/>
<xsl:include href="./xhtml/upload.xsl"/>
<xsl:include href="./xhtml/video.xsl"/>
<xsl:include href="./xhtml/register.xsl"/>
<xsl:include href="./xhtml/account.xsl"/>

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

<!-- this kills 99% of the processed XML... sorry Tim Bray.... -->
<!-- had to look up Bray in Wikipedia, 2 points off my geek score -->
<xsl:template match="@*|node()">
	<xsl:if test="not(/)">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="/">
	<html xmlns="http://www.w3.org/1999/xhtml">

		<head>
			<meta http-equiv="Content-Type" content="application/xhtml+xml;charset=utf-8" />

			<xsl:choose>
				<xsl:when test="not(//@embed='true')">
					<link rel="shortcut icon" type="image/x-icon" href="/images/favicon.ico" />
					<link rel="stylesheet" type="text/css">
						<xsl:attribute name="href">
							<xsl:value-of select="//@stylesheet" />
						</xsl:attribute>
					</link>
				</xsl:when>
				<xsl:when test="//@embed='true'">
<!--
				embedded stylesheet should rather be done through URL like
				"http://localhost/video/4chan%20city/3/embed=true+stylesheet=embedded.css"
-->
					<link rel="stylesheet" type="text/css">
						<xsl:attribute name="href">
							/style/embedded.css
						</xsl:attribute>
					</link>
				</xsl:when>
			</xsl:choose>

			<xsl:if test="boolean(//results)">

				<link rel="alternate" type="application/rss+xml">
					<xsl:attribute name="title">
						<xsl:value-of select="//results/@value" />
					</xsl:attribute>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_root']" />
						<xsl:value-of select="$site_strings[@id='page_results']" />
						<xsl:value-of select="//results/@value" />&#38;xslt=rss
					</xsl:attribute>
				</link>

			</xsl:if>

			<title>
				<xsl:choose>
					<xsl:when test="boolean(//frontpage)">
						<xsl:value-of select="$site_strings[@id='site_name']" />
						-
						<xsl:value-of select="$site_strings[@id='site_motto']" />
					</xsl:when>
					<xsl:when test="boolean(//resultspage)">
						<xsl:value-of select="$site_strings[@id='site_name']" />
						-
						<xsl:value-of select="$locale_strings[@id='results_for_query']" />
						"<xsl:value-of select="//resultspage/@query" />"
					</xsl:when>
					<xsl:otherwise>
<!--
					this seems to be fail
					should be fixed somehow
-->
						<xsl:value-of select="$site_strings[@id='site_name']" />
						-
						<xsl:value-of select="$site_strings[@id='site_motto']" />
					</xsl:otherwise>
				</xsl:choose>
			</title>
		</head>

		<body>
			
			<xsl:if test="not(//@embed='true')">
				<xsl:choose>
					<xsl:when test="string-length(//@username)=0">
						<div class="header1">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_login']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='login_to_upload']" />
							</a>
						</div>
						<div class="header2">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_register']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='register']" />
							</a>
							<xsl:value-of select="$locale_strings[@id='separator']" />
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_login']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='login']" />
							</a>
							<xsl:value-of select="$locale_strings[@id='separator']" />
							<img class="openid-icon" src="/images/openid-icon.png" alt="open id logo" />
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_login-openid']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='login_openid']" />
							</a>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="header1">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_upload']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='upload_video']" />
							</a>
							<xsl:value-of select="$locale_strings[@id='separator']" />
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_account_bookmarks']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='bookmarks']" />
							</a>
							<xsl:value-of select="$locale_strings[@id='separator']" />
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_account']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='account_details']" />
							</a>
						</div>
						<div class="header2">
							<xsl:value-of select="$locale_strings[@id='logged_in_as']" />
							<a>
								<xsl:attribute name="href">
									user/<xsl:value-of select="//@username" />
								</xsl:attribute>
								<xsl:value-of select="//@username" />
							</a>
							<xsl:value-of select="$locale_strings[@id='separator']" />
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$site_strings[@id='page_logout']" />
								</xsl:attribute>
								<xsl:value-of select="$locale_strings[@id='logout']" />
							</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>

				<hr />

				<xsl:if test="//message">
					<xsl:call-template name="message"/>
				</xsl:if>

				<xsl:if test="//search">
					<xsl:call-template name="searchbar"/>
				</xsl:if>

				<xsl:if test="not(//frontpage)">
					<xsl:call-template name="logo-small"/>
				</xsl:if>
			
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="//frontpage">
					<xsl:call-template name="frontpage"/>
				</xsl:when>
				<xsl:when test="//registerform">
					<xsl:call-template name="registerform"/>
				</xsl:when>
				<xsl:when test="//loginform">
					<xsl:call-template name="loginform"/>
				</xsl:when>
				<xsl:when test="//uploadform">
					<xsl:call-template name="uploadform"/>
				</xsl:when>
				<xsl:when test="//search">
					<xsl:call-template name="results"/>
				</xsl:when>
				<xsl:when test="//video">
					<xsl:call-template name="video"/>
				</xsl:when>
				<xsl:when test="//account">
					<xsl:call-template name="account"/>
				</xsl:when>
			</xsl:choose>

			<xsl:if test="not(//@embed='true')">
				<div class="footer">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="$site_strings[@id='page_authors']" />
						</xsl:attribute>
						<xsl:value-of select="$locale_strings[@id='authors']" />
					</a>
					<xsl:value-of select="$locale_strings[@id='separator']" />
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="$site_strings[@id='page_license']" />
						</xsl:attribute>
						<xsl:value-of select="$locale_strings[@id='license']" />
					</a>
					<xsl:value-of select="$locale_strings[@id='separator']" />
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="$site_strings[@id='page_source-code']" />
						</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='source_code']" />
					</a>
					<xsl:value-of select="$locale_strings[@id='separator']" />
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="$site_strings[@id='page_report_bug']" />
						</xsl:attribute>
						<xsl:value-of select="$locale_strings[@id='report_bug']" />
					</a>
				</div>
			</xsl:if>

		</body>

	</html>
</xsl:template>

<xsl:template name="logo-small">

	<a href="/">
		<img class="logo-small" src="/images/logo-small.png" alt="Yolanda logo top (160x25)" />
	</a>

</xsl:template>

<xsl:template name="searchbar">

	<div class="search-small">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_results']" />
			</xsl:attribute>
			<fieldset>
				<xsl:value-of select="$locale_strings[@id='search']" />:
				<input type="text" name="query" size="15">
					<xsl:attribute name="value">
						<xsl:if test="//results/@argument='query'">
							<xsl:value-of select="//results/@value" />
						</xsl:if>
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
	</div>

</xsl:template>

<xsl:template name="message">

	<div class="messagebox">
		<xsl:attribute name="id">
			<xsl:value-of select="/page/message/@type" />
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="/page/message/@type='error'">
				<img src="/images/tango/dialog-error.png" />
			</xsl:when>
			<xsl:when test="/page/message/@type='information'">
				<img src="/images/tango/dialog-information.png" />
			</xsl:when>
			<xsl:when test="/page/message/@type='warning'">
				<img src="/images/tango/dialog-warning.png" />
			</xsl:when>
		</xsl:choose>
		<xsl:variable name="messagetext" select="/page/message/@text" />
		<xsl:value-of select="$locale_strings[@id=$messagetext]" />
		<!-- probably one can do this on one line, dunno how -->
	</div>

</xsl:template>

<xsl:template name="tagcloud">
	<xsl:variable name="max" select="//tagcloud/tag/count[not(//tagcloud/tag/count &gt; .)]" />
	<xsl:variable name="min" select="//tagcloud/tag/count[not(//tagcloud/tag/count &lt; .)]" />
	<div class="tagcloud">
		<xsl:for-each select="//tagcloud/tag">
			<xsl:sort select="text" order="ascending" data-type="text" />
			<a class="tag">
				<xsl:attribute name="style">
<!--
				scale *should* be logarihmic, but that's not widely supportet
-->
					font-size:<xsl:value-of select="round((32-12)*(number(count)-number($min))div (number($max)-number($min)))+12" />px
				</xsl:attribute>
				<xsl:attribute name="href">
					<xsl:value-of select="$site_strings[@id='page_results']" />
					tag:
					<xsl:value-of select="text" />
				</xsl:attribute>
				
				<xsl:value-of select="text" />
<!--
				unnecessary, except for debug purposes
				(<xsl:value-of select="count" />)
-->
			</a>
			&#8204;
		</xsl:for-each>
	</div>

</xsl:template>


</xsl:stylesheet>
