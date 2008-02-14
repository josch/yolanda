<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="loginform">
	<div class="loginform">
		<xsl:choose>
			<xsl:when test="//loginform/@action='openid'">
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='path_login']" />
					</xsl:attribute>
					<fieldset>
						<input name="action" type="hidden" value="openid" />
						OpenID:
						<br />
						<input name="user" type="text" style="background: url(http://stat.livejournal.com/img/openid-inputicon.gif) no-repeat; background-color: #fff; background-position: 0 50%; padding-left: 18px;" />
						<br />
						e.g. http://username.myopenid.com
						<br />
						<input type="submit" name="login" >
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_login']" />
							</xsl:attribute>
						</input>
						<br />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='path_login']" />
							</xsl:attribute>
							login with normal account
						</a>
					</fieldset>
				</form>
			</xsl:when>
			<xsl:otherwise>
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='path_login']" />
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
						<br />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='path_login-openid']" />
							</xsl:attribute>
							login with openid
						</a>
					</fieldset>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</div>

</xsl:template>

</xsl:stylesheet>