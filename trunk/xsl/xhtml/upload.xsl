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
				<h2>Basic Description</h2>
				<p>These entries describe the very nature of your upload. All fields are required to be filled appropriately.</p>
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
					<fieldset>
						<input type="hidden" name="page" value="2" />
						<div>
							<xsl:value-of select="$locale_strings[@id='instruction_title']" />
							<br />
							<input name="DC.Title" type="text" size="30">
								<xsl:attribute name="value">
									<xsl:value-of select="//uploadform/@DC.Title" />
								</xsl:attribute>
							</input>
						</div>
						<div>
							<xsl:value-of select="$locale_strings[@id='instruction_subject']" />
							<br />
							<input name="DC.Subject" type="text" size="30">
								<xsl:attribute name="value">
									<xsl:value-of select="//uploadform/@DC.Subject" />
								</xsl:attribute>
							</input>
						</div>
						<div>
							<xsl:value-of select="$locale_strings[@id='instruction_description']" />
							<br />
							<textarea name="DC.Description" cols="60" rows="2">
								<xsl:value-of select="//uploadform/@DC.Description" />
							</textarea>
						</div>
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
				<h2>Uploads that match your description</h2>
				<p>If the attributes you just entered is imilar to those of already uploaded videos you will see the results below.</p>
				<p>Please check if your video is not among them and then click next to proceed.</p>
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
						<input type="submit" name="1">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_previous_page']" />
							</xsl:attribute>
						</input>
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
				<h2>Additional information</h2>
				<p>The following fields are optional but recommended.</p>
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
						<div class="messagebox">
							<xsl:value-of select="$locale_strings[@id='instruction_creator']" />
							<br />
							<input type="radio" name="creator" value="user" />myself
							<br />
							<input type="radio" name="creator" value="other" />other:
							<br />
							<input name="DC.Creator" type="text" size="30" />
							</div>
						<div class="messagebox">
							<xsl:value-of select="$locale_strings[@id='instruction_source']" />
							<br />
							<input name="DC.Source" type="text" size="30" />
						</div>
						<div class="messagebox">
							<xsl:value-of select="$locale_strings[@id='instruction_language']" />
							<br />
							<select name="DC.Language">
								<option>English</option>
								<option>German</option>
							</select>
						</div>
						<div class="messagebox">
							<xsl:value-of select="$locale_strings[@id='instruction_coverage']" />
							<br />
							<input name="DC.Coverage" type="text" size="30" />
						</div>
						<input type="submit" name="2">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_previous_page']" />
							</xsl:attribute>
						</input>
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
				<h2>Licensing</h2>
				<p>If you are the copyright holder feel free to use creative commons to license your work. If not, select the original license of your video.</p>
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
						<div class="messagebox">
							<input type="radio" name="license" checked="checked" />none
							<br />
							<input type="radio" name="license" />proprietary
							<br />
							<input type="radio" name="license" />public domain
							<br />
							<input type="radio" name="license" />creative commons
							<br />
							<select>
								<option>cc-by</option>
								<option>cc-by-sa</option>
								<option>cc-by-sa-nc</option>
								<option>cc-by-nc</option>
								<option>cc-by-nd</option>
								<option>cc-by-nd-nc</option>
							</select>
						</div>
						<input type="submit" name="3">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_previous_page']" />
							</xsl:attribute>
						</input>
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
				<h2>Summary</h2>
				<p>Please check everything for correctness and edit if neccessary.</p>
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
						<div class="messagebox">
							title:
							<br />
							subject:
							<br />
							description:
							<br />
							<input type="submit" name="1">
								<xsl:attribute name="value">
									<xsl:value-of select="$locale_strings[@id='button_page_1']" />
								</xsl:attribute>
							</input>
						</div>
						<div class="messagebox">
							creator:
							<br />
							source:
							<br />
							language:
							<br />
							coverage:
							<br />
							<input type="submit" name="3">
								<xsl:attribute name="value">
									<xsl:value-of select="$locale_strings[@id='button_page_3']" />
								</xsl:attribute>
							</input>
						</div>
						<div class="messagebox">
							license:
							<br />
							<input type="submit" name="4">
								<xsl:attribute name="value">
									<xsl:value-of select="$locale_strings[@id='button_page_4']" />
								</xsl:attribute>
							</input>
						</div>
					</fieldset>
				</form>
				<p>If Everything is okay proceed below by uploading your video.</p>
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
					<fieldset>
						<div class="messagebox">
						<xsl:value-of select="$locale_strings[@id='instruction_file']" />
						<br />
						<input name="file" type="file" size="13" />
						</div>
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