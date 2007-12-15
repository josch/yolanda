<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="innerresults">

	<xsl:for-each select="//results/result">
		<div>
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
			<br />
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
				</xsl:attribute>
				<xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
			<xsl:variable name="minutes" select="floor(@duration div 60)" />
			<xsl:variable name="hours" select="floor(@duration div 3600)" />
			<xsl:variable name="seconds" select="@duration - $minutes*60 - $hours*3600" />
			<xsl:choose>
				<xsl:when test="$hours=0">
					(<xsl:value-of select="concat(format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
				</xsl:when>
				<xsl:otherwise>
					(<xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
				</xsl:otherwise>
			</xsl:choose>
			</a>
			<br />
			<xsl:choose>
				<xsl:when test="@status=0">
					processing, please wait....
				</xsl:when>
				<xsl:when test="@status=2">
					invalid audio and/or video stream
				</xsl:when>
				<xsl:when test="@status=3">
					file not found - contact the admin
				</xsl:when>
				<xsl:when test="@status=4">
					file is not a video
				</xsl:when>
				<xsl:when test="@status=5">
					same video was already uploaded
				</xsl:when>
			</xsl:choose>
			<br />
			<xsl:value-of select="@viewcount" />
			<xsl:value-of select="$locale_strings[@id='viewcount']" />
			<xsl:if test="@edit='true'">
			<a>
				<xsl:attribute name="href">
					<xsl:choose>
						<xsl:when test="not(@status=1)">
							<xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(rdf:RDF/cc:Work/dc:identifier, 'action=edit')" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<img src="/images/tango/accessories-text-editor.png" style="border:0;vertical-align:bottom;" />edit
			</a>
			</xsl:if>
		</div>
	</xsl:for-each>
</xsl:template>

<xsl:template name="results">
	<div>
		<xsl:choose>
			<xsl:when test="//results/@value!=''">
				<xsl:if test="//results/@argument='query'">
					<!-- <xsl:value-of select="$locale_strings[@id='results_for_query']" /> -->
					<i><xsl:value-of select="//results/@value" /></i><br />
				</xsl:if>
				<xsl:if test="//results/@orderby!=''">
					<xsl:value-of select="$locale_strings[@id='ordered_by']" />
					<xsl:choose>
						<xsl:when test="//results/@orderby='relevance'">
							<xsl:value-of select="$locale_strings[@id='relevance']" />
						</xsl:when>
						<xsl:when test="//results/@orderby='duration'">
							<xsl:value-of select="$locale_strings[@id='duration']" />
						</xsl:when>
						<xsl:when test="//results/@orderby='filesize'">
							<xsl:value-of select="$locale_strings[@id='filesize']" />
						</xsl:when>
						<xsl:when test="//results/@orderby='viewcount'">
							<xsl:value-of select="$locale_strings[@id='viewcount']" />
						</xsl:when>
						<xsl:when test="//results/@orderby='downloadcount'">
							<xsl:value-of select="$locale_strings[@id='downloadcount']" />
						</xsl:when>
						<xsl:when test="//results/@orderby='timestamp'">
							<xsl:value-of select="$locale_strings[@id='timestamp']" />
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="//results/@sort='asc'">
							<xsl:value-of select="$locale_strings[@id='ascending']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$locale_strings[@id='descending']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:when test="//results/@orderby!=''">
				<xsl:choose>
					<xsl:when test="//results/@orderby='timestamp'">
						<xsl:choose>
							<xsl:when test="//results/@sort='asc'">
								<xsl:value-of select="$locale_strings[@id='videos_oldest']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$locale_strings[@id='videos_newest']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="//results/@orderby='downloadcount'">
						<xsl:choose>
							<xsl:when test="//results/@sort='asc'">
								<xsl:value-of select="$locale_strings[@id='videos_downloaded_least']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$locale_strings[@id='videos_downloaded_most']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="//results/@orderby='viewcount'">
						<xsl:choose>
							<xsl:when test="//results/@sort='asc'">
								<xsl:value-of select="$locale_strings[@id='videos_viewed_least']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$locale_strings[@id='videos_viewed_most']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="//results/@orderby='duration'">
						<xsl:choose>
							<xsl:when test="//results/@sort='asc'">
								<xsl:value-of select="$locale_strings[@id='videos_shortest']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$locale_strings[@id='videos_lengthest']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="//results/@orderby='filesize'">
						<xsl:choose>
							<xsl:when test="//results/@sort='asc'">
								<xsl:value-of select="$locale_strings[@id='videos_smallest']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$locale_strings[@id='videos_biggest']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</div>
	<div>
		<xsl:value-of select="//results/@resultcount" />&#160;
		<xsl:value-of select="$locale_strings[@id='results_on']" />&#160;
		<xsl:value-of select="//results/@lastpage" />&#160;
		<xsl:value-of select="$locale_strings[@id='pages']" />
	</div>

	<xsl:call-template name="innerresults"/>
	<xsl:call-template name="pagination-arrows"/>
	<xsl:call-template name="pagination-numbers"/>
	
	<div>
		<form method="get">
			<xsl:attribute name="action">
				<xsl:value-of select="//results/@scriptname" />
			</xsl:attribute>
			<fieldset>
				<input type="hidden">
					<xsl:attribute name="name">
						<xsl:value-of select="//results/@argument" />
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="//results/@value" />
					</xsl:attribute>
				</input>
				order by: 
				<select name="orderby">
					<xsl:if test="//results/@query!=''">
						<option value="relevance">
							<xsl:if test="//results/@orderby='relevance'">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="$locale_strings[@id='relevance']" />
						</option>
					</xsl:if>
					<option value="filesize">
						<xsl:if test="//results/@orderby='filesize'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='filesize']" />
					</option>
					<option value="duration">
						<xsl:if test="//results/@orderby='duration'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='duration']" />
					</option>
					<option value="viewcount">
						<xsl:if test="//results/@orderby='viewcount'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='viewcount']" />
					</option>
					<option value="downloadcount">
						<xsl:if test="//results/@orderby='downloadcount'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='downloadcount']" />
					</option>
					<option value="timestamp">
						<xsl:if test="//results/@orderby='timestamp'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='timestamp']" />
					</option>
					</select>
					<select name="sort">
					<option value="desc">
						<xsl:if test="//results/@sort='desc'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='descending']" />
					</option>
					<option value="asc">
						<xsl:if test="//results/@sort='asc'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$locale_strings[@id='ascending']" />
					</option>
				</select>
				pagesize:
				<select name="pagesize">
					<option>
						<xsl:if test="//results/@pagesize='1'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						1
					</option>
					<option>
						<xsl:if test="//results/@pagesize='2'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						2
					</option>
					<option>
						<xsl:if test="//results/@pagesize='5'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						5
					</option>
					<option>
						<xsl:if test="//results/@pagesize='10'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						10
					</option>
					<option>
						<xsl:if test="//results/@pagesize='20'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						20
					</option>
					<option>
						<xsl:if test="//results/@pagesize='50'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						50
					</option>
					<option>
						<xsl:if test="//results/@pagesize='100'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						100
					</option>
				</select>
				<input type="submit" />
			</fieldset>
		</form>
	</div>
	
</xsl:template>

<xsl:template name="pagination-arrows">
	<xsl:variable name="query_string" select="concat('/', //results/@scriptname, '?', //results/@argument, '=', //results/@value, '&amp;orderby=', //results/@orderby, '&amp;sort=', //results/@sort, '&amp;pagesize=', //results/@pagesize)" />
	<div>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=1')" />
			</xsl:attribute>
			<xsl:if test="//results/@currentpage&lt;=1">
				<xsl:attribute name="style">
					visibility: hidden;
				</xsl:attribute>
			</xsl:if>
			<img src="./images/tango/go-first.png" />
		</a>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage - 1)" />
			</xsl:attribute>
			<xsl:if test="//results/@currentpage&lt;=1">
				<xsl:attribute name="style">
					visibility: hidden;
				</xsl:attribute>
			</xsl:if>
			<img src="./images/tango/go-previous.png" />
		</a>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage + 1)" />
			</xsl:attribute>
			<xsl:if test="//results/@lastpage&lt;=//results/@currentpage">
				<xsl:attribute name="style">
					visibility: hidden;
				</xsl:attribute>
			</xsl:if>
			<img src="./images/tango/go-next.png" />
		</a>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=', //results/@lastpage)" />
			</xsl:attribute>
			<xsl:if test="//results/@lastpage&lt;=//results/@currentpage">
				<xsl:attribute name="style">
					visibility: hidden;
				</xsl:attribute>
			</xsl:if>
			<img src="./images/tango/go-last.png" />
		</a>
	</div>
</xsl:template>

<xsl:template name="pagination-numbers">
<!--
	this template is currently unused,
	it will probably be removed soon.
-->
	<xsl:variable name="query_string" select="concat('/', //results/@scriptname, '?', //results/@argument, '=', //results/@value, '&amp;orderby=', //results/@orderby, '&amp;sort=', //results/@sort, '&amp;pagesize=', //results/@pagesize)" />
	<xsl:if test="//results/@currentpage > 2">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage - 2)" />
			</xsl:attribute>
			<xsl:value-of select="//results/@currentpage - 2" />
		</a>
	</xsl:if>
	<xsl:if test="//results/@currentpage > 1">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage - 1)" />
			</xsl:attribute>
			<xsl:value-of select="//results/@currentpage - 1" />
		</a>
	</xsl:if>
	<xsl:value-of select="//results/@currentpage" />
	<xsl:variable name="temp" select="//results/@lastpage - //results/@currentpage" />
	<xsl:if test="$temp > 0">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage + 1)" />
			</xsl:attribute>
			<xsl:value-of select="//results/@currentpage + 1" />
		</a>
	</xsl:if>
	<xsl:if test="$temp > 1">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage + 2)" />
			</xsl:attribute>
			<xsl:value-of select="//results/@currentpage + 2" />
		</a>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
