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

<xsl:variable name="site_strings" select="document('../site/gnutube.xml')//strings" />
<xsl:variable name="locale_strings" select="document(concat('../locale/',/page/@locale,'.xml'))//strings" />

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
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_login']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='login_to_upload']" />
						</a>
					</div>
					<div class="header2">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_register']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='register']" />
						</a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_login']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='login']" />
						</a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<img class="openid-icon" src="./images/openid-icon.png" alt="open id logo" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_login-openid']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='login_openid']" />
						</a>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="header1">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_upload']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='upload_video']" />
						</a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_bookmarks']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='bookmarks']" />
						</a>
						<xsl:value-of select="$locale_strings/str[@id='separator']" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_account']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='account_details']" />
						</a>
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
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings/str[@id='page_logout']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings/str[@id='logout']" />
						</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<hr />

			<xsl:apply-templates />

			<div class="footer">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings/str[@id='page_gnutube-authors']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings/str[@id='gnutube_authors']" />
				</a>
				<xsl:value-of select="$locale_strings/str[@id='separator']" />
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings/str[@id='page_gnutube-license']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings/str[@id='gnutube_license']" />
				</a>
				<xsl:value-of select="$locale_strings/str[@id='separator']" />
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings/str[@id='page_gnutube-source-code']" />
					</xsl:attribute>
				<xsl:value-of select="$locale_strings/str[@id='gnutube_source_code']" />
				</a>
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
				<xsl:value-of select="$site_strings/str[@id='page_results']" />
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
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$site_strings/str[@id='page_query_latestadditions']" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings/str[@id='query_latestadditions']" />
		</a>
		<xsl:value-of select="$locale_strings/str[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='query_mostdownloads']" /></a>
		<xsl:value-of select="$locale_strings/str[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings/str[@id='query_bestrated']" /></a>
	</div>

</xsl:template>

<xsl:template name="searchbar">

	<div class="logo-small-top">
		<img src="./images/logo-small-top.png" alt="GNUtube logo top (160x25)" />
	</div>

	<div class="search-small">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings/str[@id='page_results']" />
			</xsl:attribute>
			<fieldset>
				<xsl:value-of select="$locale_strings/str[@id='search']" />:
				<input type="text" name="query" size="auto" />
			</fieldset>
		</form>
	</div>

	<div class="logo-small-bottom">
		<img src="./images/logo-small-bottom.png" alt="GNUtube logo top (160x25)" />
	</div>

</xsl:template>

<xsl:template match="message">

	<div class="messagebox">
		<xsl:attribute name="id">
			<xsl:value-of select="@type" />
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="@type='error'">
				<img src="./images/tango/dialog-error.png" />
			</xsl:when>
			<xsl:when test="@type='information'">
				<img src="./images/tango/dialog-information.png" />
			</xsl:when>
			<xsl:when test="@type='warning'">
				<img src="./images/tango/dialog-warning.png" />
			</xsl:when>
		</xsl:choose>
		<xsl:variable name="messagetext" select="@text" />
		<xsl:value-of select="$locale_strings/str[@id=$messagetext]" />
		<!-- probably one can do this on one line, dunno how -->
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
					<xsl:value-of select="$site_strings/str[@id='page_results']" />
					tag:
					<xsl:value-of select="text" />
				</xsl:attribute>
				<xsl:value-of select="text" />
				(<xsl:value-of select="count" />)
			</a>
		</xsl:for-each>
	</div>

</xsl:template>

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
					<xsl:value-of select="$locale_strings/str[@id='DC.Title']" />: <xsl:value-of select="rdf:RDF/cc:Work/dc:title" /><br />
					<xsl:value-of select="$locale_strings/str[@id='DC.Creator']" />: <xsl:value-of select="rdf:RDF/cc:Work/dc:creator" /><br />
					<xsl:value-of select="$locale_strings/str[@id='DC.Publisher']" />: <xsl:value-of select="rdf:RDF/cc:Work/dc:publisher" />
				</td>
			</tr>
		</xsl:for-each>
	</table>

</xsl:template>

<xsl:template match="video">

	<xsl:call-template name="searchbar"/>

	<div class="video">
		<applet
			code="com.fluendo.player.Cortado.class"
			archive="./java/cortado-ovt-stripped-0.2.2.jar"
			width="350"
			height="250"
		>
			<param name="url">
				<xsl:attribute name="value">
					<xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
				</xsl:attribute>
			</param>
			<param name="seekable" value="true"/>
			<param name="duration" value="8"/>
			<param name="keepAspect" value="true"/>
			<param name="video" value="true"/>
			<param name="audio" value="true"/>
			<param name="statusHeight" value="24"/>
			<param name="autoPlay" value="true"/>
			<param name="showStatus" value="show"/>
			<param name="bufferSize" value="200"/>
		</applet>
	</div>

	<div class="videodownload">
		<a>
			<xsl:attribute name="href">
			<xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
			</xsl:attribute>
			<img src="./images/tango/document-save.png" />
		</a>
		<a>
			<xsl:attribute name="href">
			<xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
			</xsl:attribute>
			<br />
			<xsl:value-of select="$locale_strings/str[@id='download_video']" />
		</a>
	</div>

	<div class="videoccdata">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="rdf:RDF/cc:License/@rdf:about" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings/str[@id='license_conditions']" />:
		</a>
		<br />
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="rdf:RDF/cc:License/@rdf:about" />
			</xsl:attribute>
<!--
			unfinished bizness
			<xsl:value-of select="@rdf:about" />
			<xsl:if test="true()">
				<img src="./images/cc/somerights.png" />
			</xsl:if>
-->
			<xsl:for-each select="rdf:RDF/cc:License/cc:permits">
<!--
				since we are talking about digital media here, distribution actually /is/ reproduction
				(also, i was too stupid to figure out how to test for both conditions).
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Reproduction'">
					<img src="./images/cc/cc-share.png" />
				</xsl:if>
-->
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Distribution'">
					<img src="./images/cc/cc-share.png" />
				</xsl:if>
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
					<img src="./images/cc/cc-remix.png" />
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="rdf:RDF/cc:License/cc:requires">
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Notice'">
					<img src="./images/cc/cc-by.png" />
				</xsl:if>
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/ShareAlike'">
					<img src="./images/cc/cc-sharealike.png" />
				</xsl:if>
<!--
				source code doesn't make much sense in video context.
				still, this is preserved for potential future use.
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/SourceCode'">
				SOURCE
				</xsl:if>
-->
			</xsl:for-each>
			<xsl:for-each select="rdf:RDF/cc:License/cc:prohibits">		
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/CommercialUse'">
					<img src="./images/cc/cc-noncommercial.png" />
				</xsl:if>
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
					<img src="./images/cc/cc-noderivatives.png" />
				</xsl:if>
			</xsl:for-each>
		</a>
	</div>

	<table class="videometadata">
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Title']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Creator']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:creator" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Subject']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:subject" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Description']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:description" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Publisher']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:publisher" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Date']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:date" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Source']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:source" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings/str[@id='DC.Rights']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:rights" />
			</td>
		</tr>
	</table>
	
	<table class="videometadata">
		<xsl:for-each select="/page/referers/referer">
			<tr>
				<td class="leftcell">
					<xsl:value-of select="@count" />
				</td>
				<td class="rightcell">
					<xsl:value-of select="@referer" />
				</td>
			</tr>
		</xsl:for-each>
	</table>
	
	<table class="videometadata">
		<xsl:for-each select="/page/comments/comment">
			<tr>
				<td class="leftcell">
					<xsl:value-of select="@user" />
				</td>
				<td class="rightcell">
					<xsl:value-of select="@text" />
				</td>
			</tr>
		</xsl:for-each>
	</table>

	<div class="">
		<form method="post" action="video.pl">
			<fieldset>
				<input name="id" type="hidden">
					<xsl:attribute name="value">
						<xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
					</xsl:attribute>
				</input>
				<xsl:value-of select="$locale_strings/str[@id='DC.Date']" />
				<br />
				<textarea name="comment" cols="50" rows="5"></textarea>
				<br />
				<input type="submit" name="send" />
			</fieldset>
		</form>
	</div>

</xsl:template>

<xsl:template match="registerform">

	<div class="registerform">

		<form method="post">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings/str[@id='page_register']" />
			</xsl:attribute>
			<fieldset>
				<xsl:value-of select="$locale_strings/str[@id='username']" />:
				<br />				
				<input name="user" type="text" size="30" maxlength="30" />
				<br />
				<xsl:value-of select="$locale_strings/str[@id='password']" />:
				<br />
				<input name="pass" type="password" size="30" maxlength="30" />
				<br />
				<input type="submit" name="register" >
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings/str[@id='button_register']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>

	</div>

</xsl:template>

<xsl:template match="loginform">

	<div class="loginform">

		<form method="post">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings/str[@id='page_login']" />
			</xsl:attribute>
			<fieldset>
				<input name="action" type="hidden" value="login" />
				<xsl:value-of select="$locale_strings/str[@id='username']" />:
				<br />				
				<input name="user" type="text" size="30" maxlength="30" />
				<br />
				<xsl:value-of select="$locale_strings/str[@id='password']" />:
				<br />
				<input name="pass" type="password" size="30" maxlength="30" />
				<br />
				<input type="submit" name="login" >
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings/str[@id='button_login']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
		<form method="post">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings/str[@id='page_login']" />
			</xsl:attribute>
			<fieldset>
				<input name="action" type="hidden" value="openid" />
				<xsl:value-of select="$locale_strings/str[@id='username']" />:
				<br />				
				<input name="user" type="text" size="30" maxlength="30" />
				<br />
				<input type="submit" name="login" >
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings/str[@id='button_login']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
	</div>

</xsl:template>

<xsl:template match="uploadform">

	<div class="uploadform">
		<xsl:choose>

			<xsl:when test="@page=1">
				<form method="post" enctype="multipart/form-data">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings/str[@id='page_uploader']" />
					</xsl:attribute>
					<fieldset>
						<xsl:value-of select="$locale_strings/str[@id='instruction_file']" />
						<br />
						<input name="file" type="file" size="13" />
						<br />
						<xsl:value-of select="$locale_strings/str[@id='instruction_title']" />
						<br />
						<input name="DC.Title" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings/str[@id='instruction_description']" />
						<br />
						<input name="DC.Description" type="text" size="30" />
						<br /><br />
						<input type="submit" name="page2" >
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings/str[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />
						<span class="protip">
							<xsl:value-of select="$locale_strings/str[@id='this_is_page_1']" />
						</span>
					</fieldset>
				</form>
			</xsl:when>

			<xsl:when test="@page=2">
				<form method="post" enctype="multipart/form-data">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings/str[@id='page_uploader']" />
					</xsl:attribute>
					<fieldset>
						<xsl:value-of select="$locale_strings/str[@id='instruction_creator']" />
						<br />
						<input name="DC.Creator" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings/str[@id='instruction_subject']" />
						<br />
						<input name="DC.Subject" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings/str[@id='instruction_source']" />
						<br />
						<input name="DC.Source" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings/str[@id='instruction_language']" />
						<br />
						<input name="DC.Language" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings/str[@id='instruction_coverage']" />
						<br />
						<input name="DC.Coverage" type="text" size="30" />
						<br />
						<input type="submit" name="page2" >
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings/str[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />
						<span class="protip">
							<xsl:value-of select="$locale_strings/str[@id='this_is_page_2']" />
						</span>
					</fieldset>
				</form>
			</xsl:when>

		</xsl:choose>
	</div>

</xsl:template>

</xsl:stylesheet>
