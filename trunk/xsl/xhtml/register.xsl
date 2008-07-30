<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="registerform">
    <div class="registerform">

        <form method="post">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_register']" />
            </xsl:attribute>
            <fieldset>
                <xsl:value-of select="$lang_strings[@id='username']" />:
                <br />                
                <input name="user" type="text" size="30" maxlength="30" />
                <br />
                <xsl:value-of select="$lang_strings[@id='password']" />:
                <br />
                <input name="pass" type="password" size="30" maxlength="30" />
                <br />
                <xsl:value-of select="$lang_strings[@id='password_repeat']" />:
                <br />
                <input name="pass_repeat" type="password" size="30" maxlength="30" />
                <br />
                <input type="submit" name="register" >
                    <xsl:attribute name="value">
                        <xsl:value-of select="$lang_strings[@id='button_register']" />
                    </xsl:attribute>
                </input>
            </fieldset>
        </form>
        
    </div>
</xsl:template>

</xsl:stylesheet>
