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

<xsl:variable name="site_strings" select="document('../site/gnutube.xml')//strings/str" />
<xsl:variable name="locale_strings" select="document(concat('../locale/',/page/@locale,'.xml'))//strings/str" />

<xsl:template match="/">
	<html xmlns="http://www.w3.org/1999/xhtml">

		<head>
			<meta http-equiv="Content-Type" content="application/xhtml+xml" />
			<link rel="shortcut icon" type="image/x-icon" href="/images/favicon.ico" />
			<link rel="stylesheet" type="text/css">
				<xsl:attribute name="href">
					<xsl:value-of select="//@stylesheet" />
				</xsl:attribute>
			</link>
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
						<xsl:value-of select="$site_strings[@id='site_name']" />
						-
						<xsl:value-of select="$site_strings[@id='site_motto']" />
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
								<xsl:value-of select="$site_strings[@id='page_bookmarks']" />
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

			<xsl:apply-templates />

			<div class="footer">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_gnutube-authors']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='gnutube_authors']" />
				</a>
				<xsl:value-of select="$locale_strings[@id='separator']" />
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_gnutube-license']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='gnutube_license']" />
				</a>
				<xsl:value-of select="$locale_strings[@id='separator']" />
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_gnutube-source-code']" />
					</xsl:attribute>
				<xsl:value-of select="$locale_strings[@id='gnutube_source_code']" />
				</a>
			</div>

		</body>

	</html>
</xsl:template>

<xsl:template match="frontpage">

	<div class="logo-big">
		<img src="/images/logo-big.png" alt="GNUtube logo (320x100)" />
	</div>

	<div class="search">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_results']" />
			</xsl:attribute>
			<fieldset>
				<input type="text" name="query" size="40" /><br />
				<input type="submit">
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_find']" />
					</xsl:attribute>
				</input>&#160;
				<input type="submit" name="lucky">
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_lucky']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
	</div>

	<div class="toplists">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$site_strings[@id='page_query_latestadditions']" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings[@id='query_latestadditions']" />
		</a>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings[@id='query_mostdownloads']" /></a>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings[@id='query_bestrated']" /></a>
	</div>

</xsl:template>

<xsl:template name="searchbar">

	<div class="logo-small-top">
		<img src="/images/logo-small-top.png" alt="GNUtube logo top (160x25)" />
	</div>

	<div class="search-small">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_results']" />
			</xsl:attribute>
			<fieldset>
				<xsl:value-of select="$locale_strings[@id='search']" />:
				<input type="text" name="query" size="auto" />
			</fieldset>
		</form>
	</div>

	<div class="logo-small-bottom">
		<img src="/images/logo-small-bottom.png" alt="GNUtube logo top (160x25)" />
	</div>

</xsl:template>

<xsl:template match="message">

	<div class="messagebox">
		<xsl:attribute name="id">
			<xsl:value-of select="@type" />
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="@type='error'">
				<img src="/images/tango/dialog-error.png" />
			</xsl:when>
			<xsl:when test="@type='information'">
				<img src="/images/tango/dialog-information.png" />
			</xsl:when>
			<xsl:when test="@type='warning'">
				<img src="/images/tango/dialog-warning.png" />
			</xsl:when>
		</xsl:choose>
		<xsl:variable name="messagetext" select="@text" />
		<xsl:value-of select="$locale_strings[@id=$messagetext]" />
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
					<xsl:value-of select="$site_strings[@id='page_results']" />
					tag:
					<xsl:value-of select="text" />
				</xsl:attribute>
				<xsl:value-of select="text" />
				(<xsl:value-of select="count" />)
			</a>
		</xsl:for-each>
	</div>

</xsl:template>

<xsl:template name="pagination">
	<div>
		<xsl:choose>
			<xsl:when test="@currentpage&lt;=1">
				&lt;&lt; &lt;
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=1')" />
					</xsl:attribute>
					&lt;&lt;
				</a>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=', @currentpage - 1)" />
					</xsl:attribute>
					&lt;
				</a>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@currentpage > 2">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=', @currentpage - 2)" />
				</xsl:attribute>
				<xsl:value-of select="@currentpage - 2" />
			</a>
		</xsl:if>
		<xsl:if test="@currentpage > 1">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=', @currentpage - 1)" />
				</xsl:attribute>
				<xsl:value-of select="@currentpage - 1" />
			</a>
		</xsl:if>
		<xsl:value-of select="@currentpage" />
		<xsl:variable name="temp" select="@lastpage - @currentpage" />
		<xsl:if test="$temp > 0">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=', @currentpage + 1)" />
				</xsl:attribute>
				<xsl:value-of select="@currentpage + 1" />
			</a>
		</xsl:if>
		<xsl:if test="$temp > 1">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=', @currentpage + 2)" />
				</xsl:attribute>
				<xsl:value-of select="@currentpage + 2" />
			</a>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@lastpage&lt;=@currentpage">
				&gt; &gt;&gt;
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=', @currentpage + 1)" />
					</xsl:attribute>
					&gt;
				</a>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat(@scriptname, '?', @argument, '=', @value, '&amp;orderby=', @orderby, '&amp;sort=', @sort, '&amp;page=', @lastpage)" />
					</xsl:attribute>
					&gt;&gt;
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>

<xsl:template match="results">
	<xsl:call-template name="searchbar"/>
	
	<div>
		<xsl:choose>
			<xsl:when test="@query!=''">
				<xsl:value-of select="$locale_strings[@id='results_for_query']" />
				"<xsl:value-of select="@query" />"
				<xsl:if test="@orderby!=''">
					<xsl:value-of select="$locale_strings[@id='ordered_by']" />
					<xsl:choose>
						<xsl:when test="@orderby='relevance'">
							<xsl:value-of select="$locale_strings[@id='relevance']" />
						</xsl:when>
						<xsl:when test="@orderby='duration'">
							<xsl:value-of select="$locale_strings[@id='duration']" />
						</xsl:when>
						<xsl:when test="@orderby='filesize'">
							<xsl:value-of select="$locale_strings[@id='filesize']" />
						</xsl:when>
						<xsl:when test="@orderby='viewcount'">
							<xsl:value-of select="$locale_strings[@id='viewcount']" />
						</xsl:when>
						<xsl:when test="@orderby='downloadcount'">
							<xsl:value-of select="$locale_strings[@id='downloadcount']" />
						</xsl:when>
						<xsl:when test="@orderby='timestamp'">
							<xsl:value-of select="$locale_strings[@id='timestamp']" />
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="@sort='asc'">
							<xsl:value-of select="$locale_strings[@id='ascending']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$locale_strings[@id='descending']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@orderby!=''">
				<xsl:choose>
					<xsl:when test="@orderby='timestamp'">
						<xsl:choose>
							<xsl:when test="@sort='asc'">
								the oldest videos
							</xsl:when>
							<xsl:otherwise>
								the newest videos
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@orderby='downloadcount'">
						<xsl:choose>
							<xsl:when test="@sort='asc'">
								the least downloaded videos
							</xsl:when>
							<xsl:otherwise>
								the most downloaded videos
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@orderby='viewcount'">
						<xsl:choose>
							<xsl:when test="@sort='asc'">
								the least viewed videos
							</xsl:when>
							<xsl:otherwise>
								the most viewed videos
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@orderby='duration'">
						<xsl:choose>
							<xsl:when test="@sort='asc'">
								the shortest videos
							</xsl:when>
							<xsl:otherwise>
								the lengthest videos
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@orderby='filesize'">
						<xsl:choose>
							<xsl:when test="@sort='asc'">
								the smallest videos
							</xsl:when>
							<xsl:otherwise>
								the biggest videos
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</div>
	<div>
		<xsl:value-of select="@resultcount" /> results on <xsl:value-of select="@lastpage" /> pages
	</div>
	
	<xsl:call-template name="pagination"/>
	
	<table class="results" align="center">
		<xsl:for-each select="result">
			<tr class="result">
				<td>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
						</xsl:attribute>
						<img>
							<xsl:attribute name="src">
								<xsl:value-of select="@thumbnail" />
							</xsl:attribute>
							<xsl:attribute name="alt">
								<xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
							</xsl:attribute>
						</img>
					</a>
				</td>
				<td><h2>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
							</xsl:attribute>
							<xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
						</a>
					</h2>
					<table class="videometadata">
						<tr>
							<td class="leftcell">
								<xsl:value-of select="$locale_strings[@id='duration']" />:
							</td>
							<td class="rightcell">
								<xsl:variable name="minutes" select="floor(@duration div 60)" />
								<xsl:variable name="hours" select="floor(@duration div 3600)" />
								<xsl:variable name="seconds" select="@duration - $minutes*60 - $hours*3600" />
								<xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />
							</td>
						</tr>
						<tr>
							<td class="leftcell">
								<xsl:value-of select="$locale_strings[@id='viewcount']" />:
							</td>
							<td class="rightcell">
								<xsl:value-of select="@viewcount" />
							</td>
						</tr>
					</table>
					<xsl:if test="@edit='true'">
						<a>
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="@duration=0">
										<xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat(rdf:RDF/cc:Work/dc:identifier, '/edit=true')" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<img src="/images/tango/accessories-text-editor.png" style="border:0;vertical-align:bottom;" />edit
						</a>
					</xsl:if>
				</td>
			</tr>
		</xsl:for-each>
	</table>
	
	<xsl:call-template name="pagination"/>
	
	<div>
		<form method="get">
			<xsl:attribute name="action">
				<xsl:value-of select="@scriptname" />
			</xsl:attribute>
			<fieldset>
				<input type="hidden">
					<xsl:attribute name="name">
						<xsl:value-of select="@argument" />
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="@value" />
					</xsl:attribute>
				</input>
				order by: 
				<select name="orderby">
				<xsl:if test="@query!=''">
					<option value="relevance">
						<xsl:if test="@orderby='relevance'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='relevance']" />
					</option>
				</xsl:if>
				<option value="filesize">
					<xsl:if test="@orderby='filesize'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='filesize']" />
				</option>
				<option value="duration">
					<xsl:if test="@orderby='duration'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='duration']" />
				</option>
				<option value="viewcount">
					<xsl:if test="@orderby='viewcount'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='viewcount']" />
				</option>
				<option value="downloadcount">
					<xsl:if test="@orderby='downloadcount'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='downloadcount']" />
				</option>
				<option value="timestamp">
					<xsl:if test="@orderby='timestamp'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='timestamp']" />
				</option>
				</select>
				<select name="sort">
				<option value="desc">
					<xsl:if test="@sort='desc'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='descending']" />
				</option>
				<option value="asc">
					<xsl:if test="@sort='asc'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='ascending']" />
				</option>
				</select>
				<input type="submit" />
			</fieldset>
		</form>
	</div>

</xsl:template>

<xsl:template match="video">

	<xsl:call-template name="searchbar"/>

	<div class="video">
		<xsl:choose>
			<xsl:when test="@cortado='true'">
				<applet
					code="com.fluendo.player.Cortado.class"
					archive="/java/cortado-ovt-stripped-0.2.2.jar"
				>
					<xsl:attribute name="width">
						<xsl:value-of select="@width" />
					</xsl:attribute>
					<xsl:attribute name="height">
						<xsl:value-of select="@height" />
					</xsl:attribute>
					<param name="url">
						<xsl:attribute name="value">
							<xsl:value-of select="concat(rdf:RDF/cc:Work/@rdf:about,'/view=true')" />
						</xsl:attribute>
					</param>
					<param name="seekable" value="true"/>
					<param name="duration">
						<xsl:attribute name="value">
							<xsl:value-of select="@duration" />
						</xsl:attribute>
					</param>
					<param name="keepAspect" value="true"/>
					<param name="video" value="true"/>
					<param name="audio" value="true"/>
					<param name="statusHeight" value="24"/>
					<param name="autoPlay" value="true"/>
					<param name="showStatus" value="show"/>
					<param name="bufferSize" value="200"/>
				</applet>
				<div>
					<a>
						<xsl:attribute name="href">
						<xsl:value-of select="concat(rdf:RDF/cc:Work/dc:identifier, '/cortado=false')" />
						</xsl:attribute>
						Watch using Browser Video Plugin
					</a>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<object>
					<xsl:attribute name="width">
						<xsl:value-of select="@width" />
					</xsl:attribute>
					<xsl:attribute name="height">
						<xsl:value-of select="@height + 16" />
					</xsl:attribute>
					<xsl:attribute name="data">
						<xsl:value-of select="concat(rdf:RDF/cc:Work/@rdf:about,'/view=true')" />
					</xsl:attribute>
				</object>
				<div>
					<a>
						<xsl:attribute name="href">
						<xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
						</xsl:attribute>
						Watch using Cortado Java Applet
					</a>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<div class="videodownload">
		<a>
			<xsl:attribute name="href">
			<xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
			</xsl:attribute>
			<img src="/images/tango/document-save.png" />
		</a>
		<a>
			<xsl:attribute name="href">
			<xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
			</xsl:attribute>
			<br />
			<xsl:value-of select="$locale_strings[@id='download_video']" />
		</a>
	</div>

	<div class="videoccdata">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="rdf:RDF/cc:License/@rdf:about" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings[@id='license_conditions']" />:
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
				<xsl:value-of select="$locale_strings[@id='DC.Title']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings[@id='DC.Creator']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:creator" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings[@id='DC.Subject']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:subject" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings[@id='DC.Description']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:description" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings[@id='DC.Publisher']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:publisher" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings[@id='DC.Date']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:date" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings[@id='DC.Source']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:source" />
			</td>
		</tr>
		<tr>
			<td class="leftcell">
				<xsl:value-of select="$locale_strings[@id='DC.Rights']" />:
			</td>
			<td class="rightcell">
				<xsl:value-of select="rdf:RDF/cc:Work/dc:rights" />
			</td>
		</tr>
	</table>
	
	<table class="referer">
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
	
	<div class="commentform">
		<form method="post">
			<xsl:attribute name="action">
				<xsl:value-of select="/page/video/rdf:RDF/cc:Work/dc:identifier" />
			</xsl:attribute>
			<fieldset>
				<br />
				<textarea name="comment" cols="30" rows="3" />
				<br />
				<input type="submit" name="send">
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='comment_post']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
	</div>

</xsl:template>

<xsl:template match="comments">

	<div class="comments">
		<span class="protip">
			<xsl:value-of select="$locale_strings[@id='comment_on_video']" />
		</span>
		<br />
		<xsl:for-each select="comment">
			<div class="comment">
				<a>
					<xsl:attribute name="href">
						./user/<xsl:value-of select="@username" />
					</xsl:attribute>
					<xsl:value-of select="@username" />
				</a>:
				<br />
				<xsl:value-of select="." />
			</div>
		</xsl:for-each>
	</div>

</xsl:template>

<xsl:template match="registerform">

	<div class="registerform">

		<form method="post">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_register']" />
			</xsl:attribute>
			<fieldset>
				<xsl:value-of select="$locale_strings[@id='username']" />:
				<br />				
				<input name="user" type="text" size="30" maxlength="30" />
				<br />
				<xsl:value-of select="$locale_strings[@id='password']" />:
				<br />
				<input name="pass" type="password" size="30" maxlength="30" />
				<br />
				<input type="submit" name="register" >
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_register']" />
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
				<xsl:value-of select="$site_strings[@id='page_login']" />
			</xsl:attribute>
			<fieldset>
				<input name="action" type="hidden" value="login" />
				<xsl:value-of select="$locale_strings[@id='username']" />:
				<br />				
				<input name="user" type="text" size="30" maxlength="30" />
				<br />
				<xsl:value-of select="$locale_strings[@id='password']" />:
				<br />
				<input name="pass" type="password" size="30" maxlength="30" />
				<br />
				<input type="submit" name="login" >
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_login']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
		<form method="post">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_login']" />
			</xsl:attribute>
			<fieldset>
				<input name="action" type="hidden" value="openid" />
				<xsl:value-of select="$locale_strings[@id='username']" />:
				<br />				
				<input name="user" type="text" size="30" maxlength="30" />
				<br />
				<input type="submit" name="login" >
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_login']" />
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
						<xsl:value-of select="$site_strings[@id='page_uploader']" />
					</xsl:attribute>
					<fieldset>
						<xsl:value-of select="$locale_strings[@id='instruction_file']" />
						<br />
						<input name="file" type="file" size="13" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_title']" />
						<br />
						<input name="DC.Title" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_description']" />
						<br />
						<input name="DC.Description" type="text" size="30" />
						<br /><br />
						<input type="submit" name="page2" >
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />
						<span class="protip">
							<xsl:value-of select="$locale_strings[@id='this_is_page_1']" />
						</span>
					</fieldset>
				</form>
			</xsl:when>

			<xsl:when test="@page=2">
				<form method="post" enctype="multipart/form-data">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_uploader']" />
					</xsl:attribute>
					<fieldset>
						<xsl:value-of select="$locale_strings[@id='instruction_creator']" />
						<br />
						<input name="DC.Creator" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_subject']" />
						<br />
						<input name="DC.Subject" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_source']" />
						<br />
						<input name="DC.Source" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_language']" />
						<br />
						<input name="DC.Language" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_coverage']" />
						<br />
						<input name="DC.Coverage" type="text" size="30" />
						<br />
						<input type="submit" name="page2" >
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />
						<span class="protip">
							<xsl:value-of select="$locale_strings[@id='this_is_page_2']" />
						</span>
					</fieldset>
				</form>
			</xsl:when>

		</xsl:choose>
	</div>

</xsl:template>

</xsl:stylesheet>
