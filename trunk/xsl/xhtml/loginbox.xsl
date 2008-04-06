<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="loginbox">
    <div class="loginbox">

        <xsl:choose>
            <xsl:when test="string-length(//@username)=0">

                <form method="post">
                    <xsl:attribute name="action">
                        <xsl:value-of select="$site_strings[@id='path_login']" />
                    </xsl:attribute>
                    <fieldset>
                        <label for="user">
                            <xsl:value-of select="$locale_strings[@id='username']" />:
                        </label>
                        <br />                
                        <input name="user" type="text" />
                        <br />

                        <label for="pass">
                            <xsl:value-of select="$locale_strings[@id='password']" />:
                        </label>
                        <br />
                        <input name="pass" type="password" />

                        <input type="submit" name="login" >
                            <xsl:attribute name="value">
                                <xsl:value-of select="$locale_strings[@id='button_login']" />
                            </xsl:attribute>
                        </input>

                    </fieldset>
                </form>

            </xsl:when>
            <xsl:otherwise>

<!--
                <xsl:value-of select="$locale_strings[@id='logged_in_as']" />
                <a>
                    <xsl:attribute name="href">
                        user/<xsl:value-of select="//@username" />
                    </xsl:attribute>
                    <xsl:value-of select="//@username" />
                </a>
-->


            </xsl:otherwise>
        </xsl:choose>

    </div>

</xsl:template>

<xsl:template name="loginform">
<!--
    the loginform template is deprecated
-->
    <div class="loginform">
        <form method="post">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_login']" />
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
                <input type="submit" name="login" >
                    <xsl:attribute name="value">
                        <xsl:value-of select="$locale_strings[@id='button_login']" />
                    </xsl:attribute>
                </input>
            </fieldset>
        </form>
    </div>

</xsl:template>

</xsl:stylesheet>
