<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="loginbox">

    <form method="post">

        <xsl:attribute name="action">
            <xsl:value-of select="$site_strings[@id='path_login']" />
        </xsl:attribute>

        <fieldset id="loginbox">

            <legend>
                <xsl:value-of select="$lang_strings[@id='login']" />
            </legend>

            <label for="user">
                <xsl:copy-of select="$lang_strings[@id='username_or_openid']/node()" />:
            </label>
            <br />                
            <input id="username" name="user" onkeyup="check_openid();" type="text" />
            <br />

            <label for="pass">
                <xsl:value-of select="$lang_strings[@id='password']" />:
            </label>
            <br />
            <input id="password" name="pass" type="password" />

            <input type="submit" name="login" >
                <xsl:attribute name="value">
                    <xsl:value-of select="$lang_strings[@id='button_login']" />
                </xsl:attribute>
            </input>

        </fieldset>

        </form>

    <script type="text/javascript">

<!--
    this looks awfully ugly, but nevertheless generates javascript inside _valid_ XHTML
    kudos to toby white who details the solution on http://scispace.net/tow21/weblog/718.html
-->

        <xsl:text disable-output-escaping="yes">&lt;![CDATA[
        <![CDATA[

        function check_openid()
            {
            password = document.getElementById('password');
            if  (
                document.getElementById('username').value.substring(7,0).toLowerCase() == "http://"
                ||
                document.getElementById('username').value.substring(8,0).toLowerCase() == "https://"
                )
                {
                password.disabled   = true;
                password.type       = 'input';
                password.value      = ']]></xsl:text><xsl:value-of select="$lang_strings[@id='input_password_not_required']" /><xsl:text disable-output-escaping="yes"><![CDATA[';
                }
            else
                {
                password.disabled   = false;
                password.type       = 'password';
                password.value      = '';
                }
            }

        ]]]]></xsl:text>
        <xsl:text disable-output-escaping="yes">></xsl:text>
    </script>

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
                <xsl:value-of select="$lang_strings[@id='username']" />:
                <br />                
                <input name="user" type="text" size="30" maxlength="30" />
                <br />
                <xsl:value-of select="$lang_strings[@id='password']" />:
                <br />
                <input name="pass" type="password" size="30" maxlength="30" />
                <br />
                <input type="submit" name="login" >
                    <xsl:attribute name="value">
                        <xsl:value-of select="$lang_strings[@id='button_login']" />
                    </xsl:attribute>
                </input>
            </fieldset>
        </form>
    </div>

</xsl:template>

</xsl:stylesheet>
