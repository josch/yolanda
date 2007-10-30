<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://web.resource.org/cc/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.1//EN"
	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
	encoding="UTF-8"
	indent="yes"
	method="xml"
	media-type="application/xhtml+xml"
	omit-xml-declaration="no"
/>

<xsl:include href="/xsl/xhtml/results.xsl"/>
<xsl:include href="/xsl/xhtml/video.xsl"/>

<xsl:variable name="site_strings" select="document('../site/main.xml')//strings/str" />
<xsl:variable name="locale_strings" select="document(concat('../locale/',/page/@locale,'.xml'))//strings/str" />

<!-- this kills 99% of the processed XML... sorry Tim Bray.... -->
<xsl:template match="@*|node()">
	<xsl:if test="not(/)">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="/">
	<html xmlns="http://www.w3.org/1999/xhtml">

		<head>
			<meta http-equiv="Content-Type" content="application/xhtml+xml" />
			<link rel="shortcut icon" type="image/x-icon" href="/images/favicon.ico" />
			<link rel="stylesheet" type="text/css">
				<xsl:attribute name="href">
					<xsl:value-of select="//@stylesheet" />
				</xsl:attribute>
			</link>
			<title>
				<xsl:choose>
					<xsl:when test="boolean(//frontpage)">
						<xsl:value-of select="$site_strings[@id='site_name']" />
						-
						<xsl:value-of select="$site_strings[@id='site_motto']" />
					</xsl:when>
					<xsl:when test="boolean(//resultspage)">
						<xsl:value-of select="$site_strings[@id='site_name']" />
						-
						<xsl:value-of select="$locale_strings[@id='results_for_query']" />
						"<xsl:value-of select="//resultspage/@query" />"
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$site_strings[@id='site_name']" />
						-
						<xsl:value-of select="$site_strings[@id='site_motto']" />
					</xsl:otherwise>
				</xsl:choose>
			</title>
		</head>

		<body>

			<xsl:choose>
				<xsl:when test="string-length(//@username)=0">
					<div class="header1">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_login']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='login_to_upload']" />
						</a>
					</div>
					<div class="header2">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_register']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='register']" />
						</a>
						<xsl:value-of select="$locale_strings[@id='separator']" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_login']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='login']" />
						</a>
						<xsl:value-of select="$locale_strings[@id='separator']" />
						<img class="openid-icon" src="/images/openid-icon.png" alt="open id logo" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_login-openid']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='login_openid']" />
						</a>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="header1">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_upload']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='upload_video']" />
						</a>
						<xsl:value-of select="$locale_strings[@id='separator']" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_bookmarks']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='bookmarks']" />
						</a>
						<xsl:value-of select="$locale_strings[@id='separator']" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_account']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='account_details']" />
						</a>
					</div>
					<div class="header2">
						<xsl:value-of select="$locale_strings[@id='logged_in_as']" />
						<a>
							<xsl:attribute name="href">
								user/<xsl:value-of select="//@username" />
							</xsl:attribute>
							<xsl:value-of select="//@username" />
						</a>
						<xsl:value-of select="$locale_strings[@id='separator']" />
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$site_strings[@id='page_logout']" />
							</xsl:attribute>
							<xsl:value-of select="$locale_strings[@id='logout']" />
						</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<hr />
						
			<xsl:if test="not(//frontpage)">
				<xsl:call-template name="searchbar"/>
			</xsl:if>
			
			<xsl:if test="//message">
				<xsl:call-template name="message"/>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="//frontpage">
					<xsl:call-template name="frontpage"/>
				</xsl:when>
				<xsl:when test="//registerform">
					<xsl:call-template name="registerform"/>
				</xsl:when>
				<xsl:when test="//loginform">
					<xsl:call-template name="loginform"/>
				</xsl:when>
				<xsl:when test="//uploadform">
					<xsl:call-template name="uploadform"/>
				</xsl:when>
				<xsl:when test="//search">
					<xsl:call-template name="search"/>
				</xsl:when>
				<xsl:when test="//video">
					<xsl:call-template name="video"/>
				</xsl:when>
				<xsl:when test="//account">
					<xsl:call-template name="account"/>
				</xsl:when>
			</xsl:choose>

			<div class="footer">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_authors']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='authors']" />
				</a>
				<xsl:value-of select="$locale_strings[@id='separator']" />
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_license']" />
					</xsl:attribute>
					<xsl:value-of select="$locale_strings[@id='license']" />
				</a>
				<xsl:value-of select="$locale_strings[@id='separator']" />
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$site_strings[@id='page_source-code']" />
					</xsl:attribute>
				<xsl:value-of select="$locale_strings[@id='source_code']" />
				</a>
			</div>

		</body>

	</html>
</xsl:template>

<xsl:template name="frontpage">

	<div class="logo-big">
		<img src="/images/logo-big.png" alt="Yolanda logo (320x100)" />
	</div>

	<div class="search">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_results']" />
			</xsl:attribute>
			<fieldset>
				<input type="text" name="query" size="40" /><br />
				<input type="submit">
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_find']" />
					</xsl:attribute>
				</input>&#160;
				<input type="submit" name="lucky">
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_lucky']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>
	</div>

	<div class="toplists">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$site_strings[@id='page_query_latestadditions']" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings[@id='query_latestadditions']" />
		</a>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings[@id='query_mostdownloads']" /></a>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<a href="about:blank"><xsl:value-of select="$locale_strings[@id='query_bestrated']" /></a>
	</div>

	<xsl:call-template name="tagcloud"/>

</xsl:template>

<xsl:template name="search">
	<xsl:call-template name="results"/>
</xsl:template>

<xsl:template name="searchbar">

	<div class="logo-small">
		<a href="/">
			<img src="/images/logo-small.png" alt="Yolanda logo top (160x25)" />
		</a>
	</div>

	<div class="search-small">
		<form method="get" enctype="text/plain">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_results']" />
			</xsl:attribute>
			<fieldset>
				<xsl:value-of select="$locale_strings[@id='search']" />:
				<input type="text" name="query" size="auto" />
			</fieldset>
		</form>
	</div>

</xsl:template>

<xsl:template name="message">

	<div class="messagebox">
		<xsl:attribute name="id">
			<xsl:value-of select="/page/message/@type" />
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="/page/message/@type='error'">
				<img src="/images/tango/dialog-error.png" />
			</xsl:when>
			<xsl:when test="/page/message/@type='information'">
				<img src="/images/tango/dialog-information.png" />
			</xsl:when>
			<xsl:when test="/page/message/@type='warning'">
				<img src="/images/tango/dialog-warning.png" />
			</xsl:when>
		</xsl:choose>
		<xsl:variable name="messagetext" select="/page/message/@text" />
		<xsl:value-of select="$locale_strings[@id=$messagetext]" />
		<!-- probably one can do this on one line, dunno how -->
	</div>

</xsl:template>

<xsl:template name="tagcloud">

	<div class="tagcloud">
		<xsl:for-each select="//tagcloud/tag">
			<xsl:sort select="text" order="ascending" data-type="text" />
			<a class="tag">
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="count &gt;= 64">font-size:32px</xsl:when>
						<xsl:when test="count &lt;= 28">font-size:14px</xsl:when>
						<xsl:otherwise>
							font-size:<xsl:value-of select="round(number(count)div 2)" />px
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="href">
					<xsl:value-of select="$site_strings[@id='page_results']" />
					tag:
					<xsl:value-of select="text" />
				</xsl:attribute>
				<xsl:value-of select="text" />
				(<xsl:value-of select="count" />)
			</a>
		</xsl:for-each>
	</div>

</xsl:template>

<xsl:template name="registerform">
	<div class="registerform">

		<form method="post">
			<xsl:attribute name="action">
				<xsl:value-of select="$site_strings[@id='page_register']" />
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
				<xsl:value-of select="$locale_strings[@id='password_repeat']" />:
				<br />
				<input name="pass_repeat" type="password" size="30" maxlength="30" />
				<br />
				<input type="submit" name="register" >
					<xsl:attribute name="value">
						<xsl:value-of select="$locale_strings[@id='button_register']" />
					</xsl:attribute>
				</input>
			</fieldset>
		</form>

	</div>

</xsl:template>

<xsl:template name="loginform">
	<div class="loginform">
		<xsl:choose>
			<xsl:when test="//loginform/@action='openid'">
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_login']" />
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
								<xsl:value-of select="$site_strings[@id='page_login']" />
							</xsl:attribute>
							login with normal account
						</a>
					</fieldset>
				</form>
			</xsl:when>
			<xsl:otherwise>
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_login']" />
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
								<xsl:value-of select="$site_strings[@id='page_login-openid']" />
							</xsl:attribute>
							login with openid
						</a>
					</fieldset>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</div>

</xsl:template>

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
					<fieldset>
						<input type="hidden" name="page" value="2" />
						<xsl:value-of select="$locale_strings[@id='instruction_title']" />
						<br />
						<input name="DC.Title" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_subject']" />
						<br />
						<input name="DC.Subject" type="text" size="30" />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_description']" />
						<br />
						<textarea name="DC.Description" cols="50" rows="5"></textarea>
						<br /><br />
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
					<fieldset>
						<xsl:value-of select="$locale_strings[@id='instruction_creator']" />
						<br />
						<input type="radio" name="creator" value="user" />myself
						<br />
						<input type="radio" name="creator" value="other" />other:
						<br />
						<input name="DC.Creator" type="text" size="30" />
						<br />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_source']" />
						<br />
						<input name="DC.Source" type="text" size="30" />
						<br />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_language']" />
						<br />
						<select name="DC.Language">
							<option>English</option>
							<option>German</option>
						</select>
						<br />
						<br />
						<xsl:value-of select="$locale_strings[@id='instruction_coverage']" />
						<br />
						<input name="DC.Coverage" type="text" size="30" />
						<br />
						<br />
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
					<fieldset>
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
						<br />
						<br />
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
				<p>Please check everything for correctness and edit if neccessary. If Everything is okay proceed below by uploading your video.</p>
				<form method="post">
					<xsl:attribute name="action">
						<xsl:value-of select="$site_strings[@id='page_upload']" />
					</xsl:attribute>
					<fieldset>
						title:
						<br />
						subject:
						<br />
						description
						<br />
						<input type="submit" name="1">
							<xsl:attribute name="value">
								<xsl:value-of select="$locale_strings[@id='button_page_1']" />
							</xsl:attribute>
						</input>
						<br />
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
						<br />
						license:
						<br />
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

<xsl:template name="account">
	<div>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$site_strings[@id='page_account_uploads']" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings[@id='account_uploads']" />
		</a>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$site_strings[@id='page_account_settings']" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings[@id='account_settings']" />
		</a>
		<xsl:value-of select="$locale_strings[@id='separator']" />
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$site_strings[@id='page_account_bookmarks']" />
			</xsl:attribute>
			<xsl:value-of select="$locale_strings[@id='account_bookmarks']" />
		</a>
	</div>
	
	<xsl:choose>
		<xsl:when test="//account/@show='uploads'">
			<xsl:call-template name="results"/>
		</xsl:when>
		<xsl:when test="//account/@show='settings'">
			settings
		</xsl:when>
		<xsl:when test="//account/@show='bookmarks'">
			bookmarks
		</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
