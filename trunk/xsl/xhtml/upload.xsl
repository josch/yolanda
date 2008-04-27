<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>
<xsl:template name="uploadform">
    <div class="uploadform">

        <xsl:choose>

            <xsl:when test="//uploadform/@page=1">

                <h1>
                    <xsl:value-of select="$lang_strings[@id='title_page_1']" />
                </h1>
                <br />

                <span class="instruction">
                    <xsl:value-of select="$lang_strings[@id='instruction_page_1']" />
                </span>
                <br />

                <form method="post">

                    <xsl:attribute name="action">
                        <xsl:value-of select="$site_strings[@id='path_upload']" />
                    </xsl:attribute>

                    <fieldset>

                        <xsl:value-of select="$lang_strings[@id='instruction_title']" />
                        <br />

                        <input name="DC.Title" type="text">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//uploadform/@DC.Title" />
                            </xsl:attribute>
                        </input>
                        <br />

                        <xsl:value-of select="$lang_strings[@id='instruction_subject']" />
                        <br />

                        <input name="DC.Subject" type="text">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//uploadform/@DC.Subject" />
                            </xsl:attribute>
                        </input>
                        <br />

                        <xsl:value-of select="$lang_strings[@id='instruction_description']" />
                        <br />

                        <textarea name="DC.Description">
                            <xsl:value-of select="//uploadform/@DC.Description" />
                        </textarea>
                        <br />

                        <xsl:value-of select="$lang_strings[@id='instruction_coverage']" />
                        <br />

                        <select name="DC.Coverage.day"><!-- DC.Coverage.day is NOT an official qualifier -->
                            <option>
                                <xsl:value-of select="$lang_strings[@id='unit_day']" />
                            </option>
                            <xsl:call-template name="for-loop">
                                <xsl:with-param name="start">1</xsl:with-param>
                                <xsl:with-param name="end">32</xsl:with-param>
                                <xsl:with-param name="element">option</xsl:with-param>
                            </xsl:call-template>
                        </select>

                        <select name="DC.Coverage.month"><!-- DC.Coverage.month is NOT an official qualifier -->
                            <option>
                                <xsl:value-of select="$lang_strings[@id='unit_month']" />
                            </option>
                            <xsl:call-template name="for-loop">
                                <xsl:with-param name="start">1</xsl:with-param>
                                <xsl:with-param name="end">12</xsl:with-param>
                                <xsl:with-param name="element">option</xsl:with-param>
                            </xsl:call-template>
                        </select>

                        <select name="DC.Coverage.year"><!-- DC.Coverage.year is NOT an official qualifier -->
                            <option>
                                <xsl:value-of select="$lang_strings[@id='unit_year']" />
                            </option>
                            <xsl:call-template name="for-loop">
                                <xsl:with-param name="start">1890</xsl:with-param><!-- Monkeyshines, No. 1 -->
                                <xsl:with-param name="end">2008</xsl:with-param><!-- present day, present time -->
                                <xsl:with-param name="element">option</xsl:with-param>
                            </xsl:call-template>
                        </select>
                        <br />

                        <input name="DC.Coverage.placeName" type="text" size="30">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//uploadform/@DC.Coverage.placeName" />
                            </xsl:attribute>
                        </input>
                        <br />

                        <xsl:value-of select="$lang_strings[@id='instruction_language']" />
                        <br />

                        <!-- one cannot access DC.Language from inside the for-each... -->
                        <xsl:variable name="language" select="//@locale" />
<!--
                        <xsl:variable name="language" select="//uploadform/@DC.Language" />
                            <option>
                                <xsl:if test="not($language)">
                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>
                                <xsl:attribute name="value"></xsl:attribute>
                                <xsl:value-of select="$lang_strings[@id='instruction_language_choose']" />
                            </option>
-->
                        <select name="DC.Language" size="1">

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
                        <br />

                        <button type="submit" name="2">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$lang_strings[@id='button_next_page']" />
                            </xsl:attribute>
                            <img src="/images/tango/32x32/actions/go-next.png">
                                <xsl:attribute name="alt">
                                    <xsl:value-of select="$lang_strings[@id='button_next_page']" />
                                </xsl:attribute>
                            </img>
                        </button>
                        <br />

                        <span class="protip">
                            <xsl:value-of select="$lang_strings[@id='this_is_page_1']" />
                        </span>

                    </fieldset>
                </form>

            </xsl:when>


<!--
    visual blockade between section that is being worked on (↑↑) and those that isn't (↓↓)
-->

            <xsl:when test="//uploadform/@page=2">

                <span class="heading">
                    <xsl:value-of select="$lang_strings[@id='title_page_2']" />
                </span>
                <br />

                <span class="instruction">
                    <xsl:value-of select="$lang_strings[@id='instruction_page_2']" />
                </span>

                <form method="post">

                    <xsl:attribute name="action">
                        <xsl:value-of select="$site_strings[@id='path_upload']" />
                    </xsl:attribute>

                    <fieldset>

                        <input type="submit" name="3">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$lang_strings[@id='button_next_page']" />
                            </xsl:attribute>
                        </input>
                        <br />

                        <span class="protip">
                            <xsl:value-of select="$lang_strings[@id='this_is_page_2']" />
                        </span>

                    </fieldset>
                </form>

                <xsl:call-template name="results-listing"/>

            </xsl:when>

            <xsl:when test="//uploadform/@page=3">

                <span class="heading">
                    <xsl:value-of select="$lang_strings[@id='title_page_3']" />
                </span>
                <br />

                <span class="instruction">
                    <xsl:value-of select="$lang_strings[@id='instruction_page_3']" />
                </span>

                <form method="post">

                    <xsl:attribute name="action">
                        <xsl:value-of select="$site_strings[@id='path_upload']" />
                    </xsl:attribute>

                    <fieldset>

                        <xsl:value-of select="$lang_strings[@id='instruction_creator']" />
                        <br />

                        <input name="DC.Creator" type="text" size="30">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//uploadform/@DC.Creator" />
                            </xsl:attribute>
                        </input>
                        <br />

                        <xsl:value-of select="$lang_strings[@id='instruction_source']" />
                        <br />

                        <input name="DC.Source" type="text" size="30">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//uploadform/@DC.Source" />
                            </xsl:attribute>
                        </input>
                        <br />

                        <input type="submit" name="4">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$lang_strings[@id='button_next_page']" />
                            </xsl:attribute>
                        </input>
                        <br />
                        <span class="protip">
                            <xsl:value-of select="$lang_strings[@id='this_is_page_3']" />
                        </span>
                    </fieldset>
                </form>
            </xsl:when>
            
            <xsl:when test="//uploadform/@page=4">
                <span class="heading">
                    <xsl:value-of select="$lang_strings[@id='title_page_4']" />
                </span>
                <br />
                <span class="instruction">
                    <xsl:value-of select="$lang_strings[@id='instruction_page_4']" />
                </span>
                <form method="post">
                    <xsl:attribute name="action">
                        <xsl:value-of select="$site_strings[@id='path_upload']" />
                    </xsl:attribute>
 
                    <fieldset>
                        <xsl:value-of select="$lang_strings[@id='instruction_rights']" />
                        <br />
                        <input name="DC.Rights" type="text" size="30">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//uploadform/@DC.Rights" />
                            </xsl:attribute>
                        </input>
                        <br />
                        <xsl:value-of select="$lang_strings[@id='instruction_license']" />
                        <br />
                        <input name="DC.License" type="text" size="30">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//uploadform/@DC.License" />
                            </xsl:attribute>
                        </input>
                        <br />
                        <xsl:value-of select="$lang_strings[@id='instruction_license_cc']" />
                        <br />
                        
                        <div class="cc-license-chooser">

                            <img src="./images/cc/cc-remix.png" />
                            <input type="radio" name="modification" value="remix">
                                <xsl:if test="//uploadform/@remix='true'">
                                    <xsl:attribute name="checked">
                                        checked
                                    </xsl:attribute>
                                </xsl:if>
                            </input>
                            <br />
                            <span class="protip">
                                <xsl:value-of select="$lang_strings[@id='instruction_license_cc_remix']" />
                            </span>
                            <br />

                            <img src="./images/cc/cc-sharealike.png" />
                            <input type="radio" name="modification" value="sharealike">
                                <xsl:if test="//uploadform/@sharealike='true'">
                                    <xsl:attribute name="checked">
                                        checked
                                    </xsl:attribute>
                                </xsl:if>
                            </input>
                            <br />
                            <span class="protip">
                                <xsl:value-of select="$lang_strings[@id='instruction_license_cc_sharealike']" />
                            </span>
                            <br />

                            <img src="./images/cc/cc-noderivatives.png" />
                            <input type="radio" name="modification" value="noderivatives">
                                <xsl:if test="//uploadform/@noderivatives='true'">
                                    <xsl:attribute name="checked">
                                        checked
                                    </xsl:attribute>
                                </xsl:if>
                            </input>
                            <br />
                            <span class="protip">
                                <xsl:value-of select="$lang_strings[@id='instruction_license_cc_noderivatives']" />
                            </span>
                            <br />

                            <img src="./images/cc/cc-noncommercial.png" />
                            <input type="checkbox" name="noncommercial" value="CommercialUse">
                                <xsl:if test="//uploadform/@noncommercial='true'">
                                    <xsl:attribute name="checked">
                                        checked
                                    </xsl:attribute>
                                </xsl:if>
                            </input>
                            <br />
                            <span class="protip">
                                <xsl:value-of select="$lang_strings[@id='instruction_license_cc_noncommercial']" />
                            </span>

                        </div>

                        <input type="submit" name="5">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$lang_strings[@id='button_next_page']" />
                            </xsl:attribute>
                        </input>
                        <br />
                        <span class="protip">
                            <xsl:value-of select="$lang_strings[@id='this_is_page_4']" />
                        </span>
                    </fieldset>
                </form>
            </xsl:when>
            
            <xsl:when test="//uploadform/@page=5">
                <span class="heading">
                    <xsl:value-of select="$lang_strings[@id='title_page_5']" />
                </span>
                <br />
                <span class="instruction">
                    <xsl:value-of select="$lang_strings[@id='instruction_page_5']" />
                </span>
                <form method="post">
                    <xsl:attribute name="action">
                        <xsl:value-of select="$site_strings[@id='path_upload']" />
                    </xsl:attribute>

                    <fieldset>

                    <table class="metadata-upload">
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Title']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Title" />
                            </td>
                        </tr>
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Subject']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Subject" />
                            </td>
                        </tr>
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Description']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Description" />
                            </td>
                        </tr>
                    </table>

                    <input type="submit" name="1">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$lang_strings[@id='button_page_1']" />
                        </xsl:attribute>
                    </input>

                    <table class="metadata-upload">
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Creator']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Creator" />
                            </td>
                        </tr>
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Source']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Source" />
                            </td>
                        </tr>
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Language']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Language" />
                            </td>
                        </tr>
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Coverage']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Coverage" />
                            </td>
                        </tr>
                    </table>

                    <input type="submit" name="3">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$lang_strings[@id='button_page_3']" />
                        </xsl:attribute>
                    </input>
                    
                    <table class="metadata-upload">
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.Rights']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.Rights" />
                            </td>
                        </tr>
                        <tr>
                            <td class="metadata-title">
                                <xsl:value-of select="$lang_strings[@id='DC.License']" />:
                            </td>
                            <td class="metadata-content">
                                <xsl:value-of select="//uploadform/@DC.License" />
                            </td>
                        </tr>
                    </table>

                    <input type="submit" name="4">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$lang_strings[@id='button_page_4']" />
                        </xsl:attribute>
                    </input>

                    </fieldset>
                </form>
                <form method="post" enctype="multipart/form-data">
                    <xsl:attribute name="action">
                        <xsl:value-of select="$site_strings[@id='path_uploader']" />
                    </xsl:attribute>

                    <fieldset>
                        <xsl:value-of select="$lang_strings[@id='instruction_file']" />
                        <br />
                        <input name="file" type="file" size="13" />
                        <br />
                        <input type="submit">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$lang_strings[@id='button_upload']" />
                            </xsl:attribute>
                        </input>
                        <br />
                        <span class="protip">
                            <xsl:value-of select="$lang_strings[@id='this_is_page_5']" />
                        </span>
                    </fieldset>
                </form>
            </xsl:when>

        </xsl:choose>
    </div>

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
