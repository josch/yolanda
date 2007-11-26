<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="account">
	<div>
		<xsl:choose>
			<xsl:when test="//account/@show='uploads'">
				<xsl:value-of select="$locale_strings[@id='account_uploads']" />
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_account_uploads']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='account_uploads']" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<xsl:choose>
			<xsl:when test="//account/@show='settings'">
				<xsl:value-of select="$locale_strings[@id='account_settings']" />
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_account_settings']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='account_settings']" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<xsl:choose>
			<xsl:when test="//account/@show='bookmarks'">
				<xsl:value-of select="$locale_strings[@id='account_bookmarks']" />
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_account_bookmarks']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='account_bookmarks']" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</div>
	
	<xsl:choose>
		<xsl:when test="//account/@show='uploads'">
			<h2>results</h2>
			<xsl:call-template name="results"/>
		</xsl:when>
		<xsl:when test="//account/@show='settings'">
			<h2>settings</h2>
			<form>
				<div>
					locale
					<br />
					<select name="DC.Language">
						<option>English</option>
						<option>German</option>
					</select>
				</div>
				<div>
					pagesize
					<br />
					<select>
						<option>1</option>
						<option>2</option>
						<option>5</option>
						<option>10</option>
						<option>20</option>
						<option>50</option>
						<option>100</option>
					</select>
				</div>
				<div>
					<input type="radio" name="cortado" value="true" />cortado
					<input type="radio" name="cortado" value="false" />video plugin
				</div>
				<div>
					<input type="submit" />
				</div>
			</form>
		</xsl:when>
		<xsl:when test="//account/@show='bookmarks'">
			<h2>bookmarks</h2>
		</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
