<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>
<xsl:template name="uploadform">

    <form method="post">

        <xsl:attribute name="action">
            <xsl:value-of select="$site_strings[@id='path_upload']" />
        </xsl:attribute>

        <fieldset>

            <legend>
                <xsl:value-of select="$lang_strings[@id='fieldset_upload']" />
            </legend>

            <ol>

                <xsl:for-each select="/page/xforms:instance/*/*">

                    <li>
                        <label>
                            <xsl:attribute name="for">
                                    <xsl:value-of select="name()"/>
                            </xsl:attribute>
                            <xsl:value-of select="name()"/>
                        </label>

                        <xsl:choose>

                            <xsl:when test="@xsi:type='xsd:base64Binary'">
                                <input type="file">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>

                                </input>
                            </xsl:when>

                            <xsl:when test="@xsi:type='xsd:normalizedString'">
                                <input type="text">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                </input>
                            </xsl:when>

                            <xsl:when test="@xsi:type='xsd:string'">
                                <textarea>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                </textarea>
                            </xsl:when>

                            <xsl:when test="@xsi:type='xsd:date'">
                                <select>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                    <option>
                                        <xsl:value-of select="$lang_strings[@id='unit_day']"/>
                                    </option>
                                    <xsl:call-template name="for-loop">
                                        <xsl:with-param name="start">1</xsl:with-param>
                                        <xsl:with-param name="end">31</xsl:with-param>
                                        <xsl:with-param name="element">option</xsl:with-param>
                                    </xsl:call-template>
                                </select>
                                <select>
                                    <option>
                                        <xsl:value-of select="$lang_strings[@id='unit_month']"/>
                                    </option>
                                    <xsl:call-template name="for-loop">
                                        <xsl:with-param name="start">1</xsl:with-param>
                                        <xsl:with-param name="end">12</xsl:with-param>
                                        <xsl:with-param name="element">option</xsl:with-param>
                                    </xsl:call-template>
                                </select>
                                <select>
                                    <option>
                                        <xsl:value-of select="$lang_strings[@id='unit_year']"/>
                                    </option>
                                    <xsl:call-template name="for-loop">
                                        <xsl:with-param name="start">1890</xsl:with-param>
                                        <xsl:with-param name="end">2008</xsl:with-param>
                                        <xsl:with-param name="element">option</xsl:with-param>
                                    </xsl:call-template>
                                </select>
                            </xsl:when>

                            <xsl:when test="@xsi:type='xsd:language'">
                                <select>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="name()"/>
                                    </xsl:attribute>
                                    <option>
                                        <xsl:value-of select="name()"/>
                                    </option>

                                    <xsl:variable name="language" select="//@locale" />

                                    <xsl:for-each select="$language_strings">

                                        <option>

                                            <xsl:attribute name="value">
                                                <xsl:value-of select="short" />
                                            </xsl:attribute>
        <!--
                                            <xsl:if test="$short=$language">
                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                            </xsl:if>
        -->
                                            <xsl:value-of select="name[@lang='en']" /><!-- language hardcoded to en - this will be solved through simple if/else -->
                                            <xsl:value-of select="name[@lang=$language]" />
                                            <xsl:value-of select="$language" /><!-- debug debug debug -->
                                        </option>

                                    </xsl:for-each>

                                </select>
                            </xsl:when>

                        </xsl:choose>

                    </li>

                </xsl:for-each>

                <li>
                    <fieldset>
                        <legend>
                            <xsl:copy-of select="$lang_strings[@id='instruction_license_cc_remix_question']/node()" />
                        </legend>
                        <label for="remix">
                            <input id="remix" type="radio" name="modification" value="remix" />
                            <xsl:copy-of select="$lang_strings[@id='instruction_license_cc_remix']/node()" />
                        </label>
                        <label for="sharealike">
                            <input id="sharealike" type="radio" name="modification" value="sharealike" />
                            <xsl:copy-of select="$lang_strings[@id='instruction_license_cc_sharealike']/node()" />
                        </label>
                        <label for="noderivatives">
                            <input id="noderivatives" type="radio" name="modification" value="noderivatives" />
                            <xsl:copy-of select="$lang_strings[@id='instruction_license_cc_noderivatives']/node()" />
                        </label>
                    </fieldset>
                </li>

                <li>
                    <fieldset>
                        <legend>
                            <xsl:copy-of select="$lang_strings[@id='instruction_license_cc_commercial_question']/node()" />
                        </legend>
                        <label for="commercial">
                            <input id="commercial" type="radio" name="commercial" value="commeercial" />
                            <xsl:copy-of select="$lang_strings[@id='instruction_license_cc_commercial']/node()" />
                        </label>
                        <label for="noncommercial">
                            <input id="noncommercial" type="radio" name="commercial" value="noncommercial" />
                            <xsl:copy-of select="$lang_strings[@id='instruction_license_cc_noncommercial']/node()" />
                        </label>
                    </fieldset>
                </li>

            </ol>

            <br />

            <button name="upload" type="submit">
                <xsl:attribute name="value">
                    <xsl:value-of select="$lang_strings[@id='button_next_page']" />
                </xsl:attribute>
                <img src="/images/tango/128x128/actions/document-send.png">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="$lang_strings[@id='button_upload_send_file']" />
                    </xsl:attribute>
                </img>
            </button>

        </fieldset>

    </form>

</xsl:template>

<xsl:template name="for-loop">
<!--
    this is some nasty recursive shit.
-->

    <xsl:param name="start" />
    <xsl:param name="end" />
    <xsl:param name="element" />

    <xsl:if test="$start &lt;= $end">
            <xsl:element name="{$element}">
                <xsl:value-of select="$start" />
            </xsl:element>
    </xsl:if>

    <xsl:if test="$start &lt;= $end">

        <xsl:call-template name="for-loop">

            <xsl:with-param name="start">
                <xsl:value-of select="$start + 1"/>
            </xsl:with-param>

            <xsl:with-param name="end">
                <xsl:value-of select="$end"/>
            </xsl:with-param>

            <xsl:with-param name="element">
                <xsl:value-of select="$element"/>
            </xsl:with-param>

        </xsl:call-template>

    </xsl:if>

</xsl:template>

</xsl:stylesheet>
