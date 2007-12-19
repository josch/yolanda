<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="settings">
	<h2><xsl:value-of select="$locale_strings[@id='settings_settings']" /></h2>
	<form method="POST">
		<xsl:attribute name="action">
			<xsl:value-of select="$site_strings[@id='page_settings']" />
		</xsl:attribute>
		<input type="hidden" name="show" value="settings" />
		<div>
			<h3><xsl:value-of select="$locale_strings[@id='settings_locale']" /></h3>
			<br />
			<select name="locale" size="2">
				<option value="en-us">
					<xsl:if test="//settings/@locale='en-us'">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='language_en-us']" />
				</option>
				<option value="de-de">
					<xsl:if test="//settings/@locale='de-de'">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$locale_strings[@id='language_de-de']" />
				</option>
			</select>
		</div>
		<div>
			<h3><xsl:value-of select="$locale_strings[@id='settings_pagesize']" /></h3>
			<br />
			<select name="pagesize" size="7">
				<option>
					<xsl:if test="//settings/@pagesize=1">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					1
				</option>
				<option>
					<xsl:if test="//settings/@pagesize=2">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					2
				</option>
				<option>
					<xsl:if test="//settings/@pagesize=5">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					5
				</option>
				<option>
					<xsl:if test="//settings/@pagesize=10">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					10
				</option>
				<option>
					<xsl:if test="//settings/@pagesize=20">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					20
				</option>
				<option>
					<xsl:if test="//settings/@pagesize=50">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					50
				</option>
				<option>
					<xsl:if test="//settings/@pagesize=100">
						<xsl:attribute name="selected">
							selected
						</xsl:attribute>
					</xsl:if>
					100
				</option>
			</select>
		</div>
		<div>
			<h3><xsl:value-of select="$locale_strings[@id='settings_cortado']" /></h3>
			<input type="radio" name="cortado" value="1">
				<xsl:if test="//settings/@cortado=1">
					<xsl:attribute name="checked">
						checked
					</xsl:attribute>
				</xsl:if>
			</input>
			<xsl:value-of select="$locale_strings[@id='watch_cortadoapplet']" />
			<br />
			<input type="radio" name="cortado" value="0">
				<xsl:if test="//settings/@cortado=0">
					<xsl:attribute name="checked">
						checked
					</xsl:attribute>
				</xsl:if>
			</input>
			<xsl:value-of select="$locale_strings[@id='watch_browserplugin']" />
		</div>
		<div>
			<input name="submit" type="submit" />
		</div>
	</form>
</xsl:template>

</xsl:stylesheet>
