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

        <!--
                        why do we need this hidden input ?
        -->
                        <input name="action" type="hidden" value="login" />

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

                <ul id="account-actions" role="navigation">

                    <li id="upload">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$site_strings[@id='path_upload']" />
                            </xsl:attribute>
                            <xsl:value-of select="$locale_strings[@id='header_upload-video']" />
                        </a>
                    </li>

<!--
                    <li id="">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$site_strings[@id='path_settings']" />
                            </xsl:attribute>
                            <xsl:value-of select="$locale_strings[@id='settings_details']" />
                        </a>
                    </li>
-->

                    <li id="logout">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$site_strings[@id='path_logout']" />
                            </xsl:attribute>
                            <xsl:value-of select="$locale_strings[@id='logout']" />
                        </a>
                    </li>

                </ul>

            </xsl:otherwise>
        </xsl:choose>

    </div>

</xsl:template>

<xsl:template name="loginform">
<!--
    the loginform template is deprecated
-->
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
