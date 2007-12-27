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

				<span class="heading">
					<xsl:value-of select="$locale_strings[@id='title_page_1']" />
				</span>
				<br />

				<span class="instruction">
					<xsl:value-of select="$locale_strings[@id='instruction_page_1']" />
				</span>
				<br />

				<form method="post">

					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_upload']" />
					</xsl:attribute>

					<input name="DC.Creator" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Creator" />
						</xsl:attribute>
					</input>

					<input name="DC.Source" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Source" />
						</xsl:attribute>
					</input>

					<input name="DC.Language" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Language" />
						</xsl:attribute>
					</input>

					<input name="DC.Coverage" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Coverage" />
						</xsl:attribute>
					</input>

					<input name="DC.Rights" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Rights" />
						</xsl:attribute>
					</input>

					<input name="DC.License" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.License" />
						</xsl:attribute>
					</input>

					<fieldset>

						<xsl:value-of select="$locale_strings[@id='instruction_title']" />
						<br />

						<input name="DC.Title" type="text" size="30">
							<xsl:attribute name="value">
								<xsl:value-of select="//uploadform/@DC.Title" />
							</xsl:attribute>
						</input>
						<br />

						<xsl:value-of select="$locale_strings[@id='instruction_subject']" />
						<br />

						<input name="DC.Subject" type="text" size="30">
							<xsl:attribute name="value">
								<xsl:value-of select="//uploadform/@DC.Subject" />
							</xsl:attribute>
						</input>
						<br />

						<xsl:value-of select="$locale_strings[@id='instruction_description']" />
						<br />

						<textarea name="DC.Description" cols="60" rows="2">
							<xsl:value-of select="//uploadform/@DC.Description" />
						</textarea>
						<br />

						<input type="submit" name="2">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />

						<span class="protip">
							<xsl:value-of select="$locale_strings[@id='this_is_page_1']" />
						</span>

					</fieldset>
				</form>

			</xsl:when>
			
			<xsl:when test="//uploadform/@page=2">

				<span class="heading">
					<xsl:value-of select="$locale_strings[@id='title_page_2']" />
				</span>
				<br />

				<span class="instruction">
					<xsl:value-of select="$locale_strings[@id='instruction_page_2']" />
				</span>

				<form method="post">

					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_upload']" />
					</xsl:attribute>

					<input name="DC.Title" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Title" />
						</xsl:attribute>
					</input>

					<input name="DC.Subject" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Subject" />
						</xsl:attribute>
					</input>

					<input name="DC.Description" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Description" />
						</xsl:attribute>
					</input>

					<input name="DC.Creator" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Creator" />
						</xsl:attribute>
					</input>

					<input name="DC.Source" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Source" />
						</xsl:attribute>
					</input>

					<input name="DC.Language" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Language" />
						</xsl:attribute>
					</input>

					<input name="DC.Coverage" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Coverage" />
						</xsl:attribute>
					</input>

					<input name="DC.Rights" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Rights" />
						</xsl:attribute>
					</input>

					<input name="DC.License" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.License" />
						</xsl:attribute>
					</input>

					<fieldset>

						<input type="submit" name="3">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />

						<span class="protip">
							<xsl:value-of select="$locale_strings[@id='this_is_page_2']" />
						</span>

					</fieldset>
				</form>

				<xsl:call-template name="innerresults"/>

			</xsl:when>

			<xsl:when test="//uploadform/@page=3">

				<span class="heading">
					<xsl:value-of select="$locale_strings[@id='title_page_3']" />
				</span>
				<br />

				<span class="instruction">
					<xsl:value-of select="$locale_strings[@id='instruction_page_3']" />
				</span>

				<form method="post">

					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_upload']" />
					</xsl:attribute>

					<input name="DC.Title" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Title" />
						</xsl:attribute>
					</input>

					<input name="DC.Subject" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Subject" />
						</xsl:attribute>
					</input>

					<input name="DC.Description" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Description" />
						</xsl:attribute>
					</input>

					<input name="DC.Rights" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Rights" />
						</xsl:attribute>
					</input>

					<input name="DC.License" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.License" />
						</xsl:attribute>
					</input>

					<fieldset>

						<xsl:value-of select="$locale_strings[@id='instruction_creator']" />
						<br />

						<input name="DC.Creator" type="text" size="30">
							<xsl:attribute name="value">
								<xsl:value-of select="//uploadform/@DC.Creator" />
							</xsl:attribute>
						</input>
						<br />

						<xsl:value-of select="$locale_strings[@id='instruction_source']" />
						<br />

						<input name="DC.Source" type="text" size="30">
							<xsl:attribute name="value">
								<xsl:value-of select="//uploadform/@DC.Source" />
							</xsl:attribute>
						</input>
						<br />

						<xsl:value-of select="$locale_strings[@id='instruction_language']" />
						<br />

						<select name="DC.Language" size="2">
							<option>
								<xsl:if test="//uploadform/@DC.Language=$locale_strings[@id='language_en-us']">
									<xsl:attribute name="selected">
										selected
									</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$locale_strings[@id='language_en-us']" />
							</option>
							<option>
								<xsl:if test="//uploadform/@DC.Language=$locale_strings[@id='language_de-de']">
									<xsl:attribute name="selected">
										selected
									</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$locale_strings[@id='language_de-de']" />
							</option>
						</select>
						<br />

						<xsl:value-of select="$locale_strings[@id='instruction_coverage']" />
						<br />

						<input name="DC.Coverage" type="text" size="30">
							<xsl:attribute name="value">
								<xsl:value-of select="//uploadform/@DC.Coverage" />
							</xsl:attribute>
						</input>
						<br />

						<input type="submit" name="4">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />
						<span class="protip">
							<xsl:value-of select="$locale_strings[@id='this_is_page_3']" />
						</span>
					</fieldset>
				</form>
			</xsl:when>
			
			<xsl:when test="//uploadform/@page=4">
				<span class="heading">
					<xsl:value-of select="$locale_strings[@id='title_page_4']" />
				</span>
				<br />
				<span class="instruction">
					<xsl:value-of select="$locale_strings[@id='instruction_page_4']" />
				</span>
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_upload']" />
					</xsl:attribute>
					<input name="DC.Title" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Title" />
						</xsl:attribute>
					</input>
					<input name="DC.Subject" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Subject" />
						</xsl:attribute>
					</input>
					<input name="DC.Description" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Description" />
						</xsl:attribute>
					</input>
					<input name="DC.Creator" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Creator" />
						</xsl:attribute>
					</input>
					<input name="DC.Source" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Source" />
						</xsl:attribute>
					</input>
					<input name="DC.Language" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Language" />
						</xsl:attribute>
					</input>
					<input name="DC.Coverage" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Coverage" />
						</xsl:attribute>
					</input>
					<fieldset>
						<xsl:value-of select="$locale_strings[@id='instruction_rights']" />
						<br />
						<input name="DC.Rights" type="text" size="30">
							<xsl:attribute name="value">
								<xsl:value-of select="//uploadform/@DC.Rights" />
							</xsl:attribute>
						</input>
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_license']" />
						<br />
						<input name="DC.License" type="text" size="30">
							<xsl:attribute name="value">
								<xsl:value-of select="//uploadform/@DC.License" />
							</xsl:attribute>
						</input>
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_license_cc']" />
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
								<xsl:value-of select="$locale_strings[@id='instruction_license_cc_remix']" />
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
								<xsl:value-of select="$locale_strings[@id='instruction_license_cc_sharealike']" />
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
								<xsl:value-of select="$locale_strings[@id='instruction_license_cc_noderivatives']" />
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
								<xsl:value-of select="$locale_strings[@id='instruction_license_cc_noncommercial']" />
							</span>

						</div>

						<input type="submit" name="5">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_next_page']" />
							</xsl:attribute>
						</input>
						<br />
						<span class="protip">
							<xsl:value-of select="$locale_strings[@id='this_is_page_4']" />
						</span>
					</fieldset>
				</form>
			</xsl:when>
			
			<xsl:when test="//uploadform/@page=5">
				<span class="heading">
					<xsl:value-of select="$locale_strings[@id='title_page_5']" />
				</span>
				<br />
				<span class="instruction">
					<xsl:value-of select="$locale_strings[@id='instruction_page_5']" />
				</span>
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_upload']" />
					</xsl:attribute>
					<input name="DC.Title" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Title" />
						</xsl:attribute>
					</input>
					<input name="DC.Subject" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Subject" />
						</xsl:attribute>
					</input>
					<input name="DC.Description" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Description" />
						</xsl:attribute>
					</input>
					<fieldset>
					<input name="DC.Title" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Title" />
						</xsl:attribute>
					</input>
					<input name="DC.Subject" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Subject" />
						</xsl:attribute>
					</input>
					<input name="DC.Description" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Description" />
						</xsl:attribute>
					</input>
					<input name="DC.Creator" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Creator" />
						</xsl:attribute>
					</input>
					<input name="DC.Source" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Source" />
						</xsl:attribute>
					</input>
					<input name="DC.Language" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Language" />
						</xsl:attribute>
					</input>
					<input name="DC.Coverage" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Coverage" />
						</xsl:attribute>
					</input>
					<input name="DC.Rights" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Rights" />
						</xsl:attribute>
					</input>
					<input name="DC.License" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.License" />
						</xsl:attribute>
					</input>

					<table class="metadata-upload">
						<tr>
							<td class="metadata-title">
								<xsl:value-of select="$locale_strings[@id='DC.Title']" />:
							</td>
							<td class="metadata-content">
								<xsl:value-of select="//uploadform/@DC.Title" />
							</td>
						</tr>
						<tr>
							<td class="metadata-title">
								<xsl:value-of select="$locale_strings[@id='DC.Subject']" />:
							</td>
							<td class="metadata-content">
								<xsl:value-of select="//uploadform/@DC.Subject" />
							</td>
						</tr>
						<tr>
							<td class="metadata-title">
								<xsl:value-of select="$locale_strings[@id='DC.Description']" />:
							</td>
							<td class="metadata-content">
								<xsl:value-of select="//uploadform/@DC.Description" />
							</td>
						</tr>
					</table>

					<input type="submit" name="1">
						<xsl:attribute name="value">
							<xsl:value-of select="$locale_strings[@id='button_page_1']" />
						</xsl:attribute>
					</input>

					<table class="metadata-upload">
						<tr>
							<td class="metadata-title">
								<xsl:value-of select="$locale_strings[@id='DC.Creator']" />:
							</td>
							<td class="metadata-content">
								<xsl:value-of select="//uploadform/@DC.Creator" />
							</td>
						</tr>
						<tr>
							<td class="metadata-title">
								<xsl:value-of select="$locale_strings[@id='DC.Source']" />:
							</td>
							<td class="metadata-content">
								<xsl:value-of select="//uploadform/@DC.Source" />
							</td>
						</tr>
						<tr>
							<td class="metadata-title">
								<xsl:value-of select="$locale_strings[@id='DC.Language']" />:
							</td>
							<td class="metadata-content">
								<xsl:value-of select="//uploadform/@DC.Language" />
							</td>
						</tr>
						<tr>
							<td class="metadata-title">
								<xsl:value-of select="$locale_strings[@id='DC.Coverage']" />:
							</td>
							<td class="metadata-content">
								<xsl:value-of select="//uploadform/@DC.Coverage" />
							</td>
						</tr>
					</table>

					<input type="submit" name="3">
						<xsl:attribute name="value">
							<xsl:value-of select="$locale_strings[@id='button_page_3']" />
						</xsl:attribute>
					</input>
					
					<table class="videometadata">
						<tr>
							<td class="leftcell">
								<xsl:value-of select="$locale_strings[@id='DC.Rights']" />:
							</td>
							<td class="rightcell">
								<xsl:value-of select="//uploadform/@DC.Rights" />
							</td>
						</tr>
						<tr>
							<td class="leftcell">
								<xsl:value-of select="$locale_strings[@id='DC.License']" />:
							</td>
							<td class="rightcell">
								<xsl:value-of select="//uploadform/@DC.License" />
							</td>
						</tr>
					</table>

					<input type="submit" name="4">
						<xsl:attribute name="value">
							<xsl:value-of select="$locale_strings[@id='button_page_4']" />
						</xsl:attribute>
					</input>

					</fieldset>
				</form>
				<form method="post" enctype="multipart/form-data">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_uploader']" />
					</xsl:attribute>
					<input name="DC.Title" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Title" />
						</xsl:attribute>
					</input>
					<input name="DC.Subject" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Subject" />
						</xsl:attribute>
					</input>
					<input name="DC.Description" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Description" />
						</xsl:attribute>
					</input>
					<input name="DC.Creator" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Creator" />
						</xsl:attribute>
					</input>
					<input name="DC.Source" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Source" />
						</xsl:attribute>
					</input>
					<input name="DC.Language" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Language" />
						</xsl:attribute>
					</input>
					<input name="DC.Coverage" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Coverage" />
						</xsl:attribute>
					</input>
					<input name="DC.Rights" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.Rights" />
						</xsl:attribute>
					</input>
					<input name="DC.License" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="//uploadform/@DC.License" />
						</xsl:attribute>
					</input>
					<fieldset>
						<xsl:value-of select="$locale_strings[@id='instruction_file']" />
						<br />
						<input name="file" type="file" size="13" />
						<br />
						<input type="submit">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_upload']" />
							</xsl:attribute>
						</input>
						<br />
						<span class="protip">
							<xsl:value-of select="$locale_strings[@id='this_is_page_5']" />
						</span>
					</fieldset>
				</form>
			</xsl:when>

		</xsl:choose>
	</div>

</xsl:template>

</xsl:stylesheet>
