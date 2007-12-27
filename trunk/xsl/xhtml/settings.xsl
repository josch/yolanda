<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="settings">

	<div class="settingsform">

		<span class="heading">
			<xsl:value-of select="$locale_strings[@id='settings_heading']" />
		</span>

		<form method="POST">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_settings']" />
			</xsl:attribute>

			<xsl:value-of select="$locale_strings[@id='settings_instruction_locale']" />
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
			<br />

			<xsl:value-of select="$locale_strings[@id='settings_instruction_pagesize']" />
			<br />

			<input name="pagesize" type="text" size="7">
				<xsl:attribute name="value">
					<xsl:value-of select="//settings/@pagesize" />
				</xsl:attribute>
			</input>
			<br />

			<xsl:value-of select="$locale_strings[@id='settings_instruction_method']" />
			<br />

			<input type="radio" name="cortado" value="true">
				<xsl:if test="//settings/@cortado='true'">
					<xsl:attribute name="checked">
						checked
					</xsl:attribute>
				</xsl:if>
			</input>

			<xsl:value-of select="$locale_strings[@id='watch_cortadoapplet']" />
			<br />
			<input type="radio" name="cortado" value="false">
				<xsl:if test="//settings/@cortado='false'">
					<xsl:attribute name="checked">
						checked
					</xsl:attribute>
				</xsl:if>
			</input>

			<xsl:value-of select="$locale_strings[@id='watch_browserplugin']" />
			<br />
			<input name="submit" type="submit" />

		</form>

	</div>

</xsl:template>

</xsl:stylesheet>
