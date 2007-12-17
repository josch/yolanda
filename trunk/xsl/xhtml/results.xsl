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
		<div class="result">
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
			</a>
			<br />
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
		</div>
	</xsl:for-each>
</xsl:template>

<xsl:template name="results-heading">

<!--
	this is deprecated - dont use it.
-->
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
</xsl:template>

<xsl:template name="results">

	<div>
		<span class="heading">
			<xsl:value-of select="$locale_strings[@id='results_heading_1']" />&#160;
			<xsl:value-of select="//results/@pagesize * (//results/@currentpage - 1) + 1" />&#160;
			<xsl:value-of select="$locale_strings[@id='results_heading_2']" />&#160;
			<xsl:choose>
				<xsl:when test="(//results/@pagesize * //results/@currentpage) &lt; //results/@resultcount">
					<xsl:value-of select="//results/@pagesize * //results/@currentpage" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//results/@resultcount" />
				</xsl:otherwise>
			</xsl:choose>&#160;
			<xsl:value-of select="$locale_strings[@id='results_heading_3']" />&#160;
			<xsl:value-of select="//results/@resultcount" />&#160;
			<xsl:value-of select="$locale_strings[@id='results_heading_4']" />&#160;
			"<xsl:value-of select="//results/@value" />"
		</span>
	</div>

	<xsl:call-template name="innerresults"/>

	<xsl:if test="//results/@lastpage &gt; 1">
		<xsl:call-template name="pagination-arrows"/>
	</xsl:if>

</xsl:template>


<xsl:template name="results-ordering">

<!--
	this is deprecated - dont use it.
-->

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

		<div class="page-number">
			<xsl:value-of select="//results/@currentpage" />
		</div>

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

</xsl:stylesheet>
