<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="video">
	<xsl:if test="not(//@embed='true')">
		<br />
		<div class="videotitle">
			<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:title" />
			<xsl:variable name="minutes" select="floor(//video/@duration div 60)" />
			<xsl:variable name="hours" select="floor(//video/@duration div 3600)" />
			<xsl:variable name="seconds" select="//video/@duration - $minutes*60 - $hours*3600" />
			<xsl:choose>
				<xsl:when test="$hours=0">
					(<xsl:value-of select="concat(format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
				</xsl:when>
				<xsl:otherwise>
					(<xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:if>
	<div class="video">
		<xsl:choose>
			<xsl:when test="//video/@cortado='true'">
				<applet
					code="com.fluendo.player.Cortado.class"
					archive="/java/cortado-ovt-stripped-0.2.2.jar"
				>
					<xsl:attribute name="width">
						<xsl:value-of select="//video/@width" />
					</xsl:attribute>
					<xsl:attribute name="height">
						<xsl:value-of select="//video/@height" />
					</xsl:attribute>
					<param name="url">
						<xsl:attribute name="value">
							<xsl:value-of select="concat(//video/rdf:RDF/cc:Work/@rdf:about,'/view=true')" />
						</xsl:attribute>
					</param>
					<param name="seekable" value="true"/>
					<param name="duration">
						<xsl:attribute name="value">
							<xsl:value-of select="//video/@duration" />
						</xsl:attribute>
					</param>
					<param name="keepAspect" value="true"/>
					<param name="video" value="true"/>
					<param name="audio" value="true"/>
					<param name="statusHeight" value="24"/>
					<param name="autoPlay" value="true"/>
					<param name="showStatus" value="show"/>
					<param name="bufferSize" value="200"/>
				</applet>
				<div class="watch-browserplugin">
					<a>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="//@embed='true'">
									<xsl:value-of select="concat(//video/rdf:RDF/cc:Work/dc:identifier, 'cortado=false&amp;embed=true')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat(//video/rdf:RDF/cc:Work/dc:identifier, 'cortado=false')" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:value-of select="$locale_strings[@id='watch_browserplugin']" />
					</a>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<object type="application/ogg">
					<xsl:attribute name="width">
						<xsl:value-of select="//video/@width" />
					</xsl:attribute>
					<xsl:attribute name="height">
						<xsl:value-of select="//video/@height + 16" />
					</xsl:attribute>
					<xsl:attribute name="data">
						<xsl:value-of select="concat(//video/rdf:RDF/cc:Work/@rdf:about,'/view=true')" />
					</xsl:attribute>
				</object>
				<div class="watch-cortadoapplet">
					<a>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="//@embed='true'">
									<xsl:value-of select="concat(//video/rdf:RDF/cc:Work/dc:identifier, 'cortado=true&amp;embed=true')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat(//video/rdf:RDF/cc:Work/dc:identifier, 'cortado=true')" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='watch_cortadoapplet']" />
					</a>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<xsl:if test="//@embed='true'">
		<div class="embedded-backlink">
			<a target="_blank">
				<xsl:attribute name="href">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:identifier" />
				</xsl:attribute>
				<xsl:value-of select="$locale_strings[@id='backlink']" />
			</a>
		</div>
	</xsl:if>

	<xsl:if test="not(//@embed='true')">
		<div class="button-download">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/@rdf:about" />
				</xsl:attribute>
				<img src="/images/tango/document-save.png" />
			</a>
			<br />
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/@rdf:about" />
				</xsl:attribute>
				<xsl:value-of select="$locale_strings[@id='download_video']" />
			</a>
			<br />
			(<xsl:value-of select="format-number(number(round(//video/@filesize) div 1048576), '0.0#')" />&#160;<xsl:value-of select="$locale_strings[@id='megabytes']" />)
		</div>
		<div class="button-edit">
			<xsl:if test="//@edit='true'">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'action=edit')" />
					</xsl:attribute>
					<img src="/images/tango/accessories-text-editor.png" />
				</a>
				<br />
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'action=edit')" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='edit_video']" />
				</a>
			</xsl:if>
		</div>
		<div class="button-bookmark">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'action=bookmark')" />
				</xsl:attribute>
				<img src="/images/tango/bookmark-new.png" />
			</a>
			<br />
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'action=bookmark')" />
				</xsl:attribute>
				<xsl:value-of select="$locale_strings[@id='bookmark_video']" />
			</a>
		</div>

		<xsl:call-template name="cclicense"/>

		<table class="videometadata">
			<tr>
				<td class="leftcell">
					<xsl:value-of select="$locale_strings[@id='DC.Creator']" />:
				</td>
				<td class="rightcell">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:creator" />
				</td>
			</tr>
			<tr>
				<td class="leftcell">
					<xsl:value-of select="$locale_strings[@id='DC.Description']" />:
				</td>
				<td class="rightcell">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:description" />
				</td>
			</tr>
			<tr>
				<td class="leftcell">
					<xsl:value-of select="$locale_strings[@id='DC.Date']" />:
				</td>
				<td class="rightcell">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:date" />
				</td>
			</tr>
			<tr>
				<td class="leftcell">
					<xsl:value-of select="$locale_strings[@id='DC.Source']" />:
				</td>
				<td class="rightcell">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:source" />
				</td>
			</tr>
			<tr>
				<td class="leftcell">
					<xsl:value-of select="$locale_strings[@id='DC.Rights']" />:
				</td>
				<td class="rightcell">
					<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:rights" />
				</td>
			</tr>
		</table>

		<div class="videostuff">
			<span class="protip-embed">
				<xsl:value-of select="$locale_strings[@id='protip_embed']" />
				<br />
				<span class="code">
					&lt;object data="<xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'embed=true')" />"
						type="application/xml"
						width=<xsl:value-of select="//video/@width + 24" />
						height=<xsl:value-of select="//video/@height + 48" />
					/&gt;
				</span>
			</span>
		</div>

		<xsl:call-template name="comments"/>
	
		<xsl:if test="not(//@username='')">
			<div class="commentform">
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="//video/rdf:RDF/cc:Work/dc:identifier" />
					</xsl:attribute>
					<fieldset>
						<br />
						<textarea name="comment" cols="30" rows="3" />
						<br />
						<input type="submit" name="send">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='comment_post']" />
							</xsl:attribute>
						</input>
					</fieldset>
				</form>
			</div>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template name="comments">

	<div class="comments">
		<span class="protip">
			<xsl:value-of select="$locale_strings[@id='comment_on_video']" />
		</span>
		<br />
		<xsl:for-each select="//comments/comment">
			<div class="comment">
				<a>
					<xsl:attribute name="href">
						/user/<xsl:value-of select="@username" />
					</xsl:attribute>
					<xsl:value-of select="@username" />
				</a>:
				<br />
				<xsl:value-of select="." />
			</div>
		</xsl:for-each>
	</div>

</xsl:template>

<xsl:template name="cclicense">

	<div class="videoccdata">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="//video/rdf:RDF/cc:License/@rdf:about" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings[@id='license_conditions']" />:
		</a>
		<br />
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="//video/rdf:RDF/cc:License/@rdf:about" />
			</xsl:attribute>
<!--
			unfinished bizness
			<xsl:value-of select="@rdf:about" />
			<xsl:if test="true()">
				<img src="./images/cc/somerights.png" />
			</xsl:if>
-->
			<xsl:for-each select="//video/rdf:RDF/cc:License/cc:permits">
<!--
				since we are talking about digital media here, distribution actually /is/ reproduction
				(also, i was too stupid to figure out how to test for both conditions).
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Reproduction'">
					<img src="./images/cc/cc-share.png" />
				</xsl:if>
-->
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Distribution'">
					<img src="./images/cc/cc-share.png" />
				</xsl:if>
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
					<img src="./images/cc/cc-remix.png" />
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="rdf:RDF/cc:License/cc:requires">
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Notice'">
					<img src="./images/cc/cc-by.png" />
				</xsl:if>
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/ShareAlike'">
					<img src="./images/cc/cc-sharealike.png" />
				</xsl:if>
<!--
				source code doesn't make much sense in video context.
				still, this is preserved for potential future use.
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/SourceCode'">
				SOURCE
				</xsl:if>
-->
			</xsl:for-each>
			<xsl:for-each select="rdf:RDF/cc:License/cc:prohibits">		
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/CommercialUse'">
					<img src="./images/cc/cc-noncommercial.png" />
				</xsl:if>
				<xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
					<img src="./images/cc/cc-noderivatives.png" />
				</xsl:if>
			</xsl:for-each>
		</a>
	</div>

</xsl:template>

</xsl:stylesheet>
