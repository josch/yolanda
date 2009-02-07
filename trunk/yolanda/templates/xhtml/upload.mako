<%inherit file="base.mako"/>

<%def name="title()">
    front page
</%def>

<%def name="heading()">
    upload video
</%def>

<form
    action="/upload/upload"
    enctype="multipart/form-data"
    method="POST"
>

    <div>
        <label for="dc_title">title</label>
        <input name="dc_title" type="text"/>
    </div>

<!--
    <div>
        <label for="dc_alternative">alternative title</label>
            <input name="dc_alternative" type="text"/>
    </div>
-->

    <div>
        <label for="dc_abstract">abstract</label>
        <textarea name="dc_abstract" />
    </div>

<!--
    <div>
        <label for="dc_spatial">spatial</label>
        <input name="dc_spatial" type="text"/>
    </div>
-->

    <div>
        <label for="dc_subject">keywords (tags), delimited by commas</label>
        <input name="dc_subject" type="text"/>
    </div>

<!--
    <div>
        <label for="dc_temporal">time the document describes (YYYY-MM-DD HH:MM:SS)</label>
        <input name="dc_temporal" type="datetime"/>
    </div>

    <div>
        <label for="dc_language">language</label>
        <select name="dc_language">
            <option value="deu">German</option>
            <option value="eng">English</option>
        </select>
    </div>
-->

<!--
    <div>
        <label for="dc_creator">creator</label>
        <input name="dc_creator" type="text"/>
    </div>


    <div>
        <label for="dc_contributor">contributors, delimited by commas</label>
        <input name="dc_contributor" type="text"/>
    </div>
-->

    <div>
        <label for="dc_rightsHolder">rights holder</label>
        <input name="dc_rightsHolder" type="text"/>
    </div>

<!--
$video->appendChild( getElementDC( "contributor", "xsd:normalizedString") );
$video->appendChild( getElementDC( "created", "xsd:date") );

$video->appendChild( getElementDC( "hasFormat", "xsd:normalizedString") );
$video->appendChild( getElementDC( "hasPart", "xsd:normalizedString") );
$video->appendChild( getElementDC( "isFormatOf", "xsd:normalizedString") );
$video->appendChild( getElementDC( "isPartOf", "xsd:normalizedString") );
$video->appendChild( getElementDC( "references", "xsd:normalizedString") );
$video->appendChild( getElementDC( "replaces", "xsd:normalizedString") );

$video->appendChild( getElementDC( "rightsHolder", "xsd:normalizedString") );
$video->appendChild( getElementDC( "source", "xsd:normalizedString") );
$video->appendChild( getElementDC( "license", "xsd:normalizedString") );
-->
    <fieldset>
        <legend>
            Is modifying the video allowed ?
        </legend>
        <label for="cc_remix">
            <input id="cc_remix" type="radio" name="modification" value="remix" />
            <strong>Yes</strong>, remixing is allowed.
        </label>
        <label for="cc_sharealike">
            <input id="cc_sharealike" type="radio" name="modification" value="sharealike" />
            <strong>Yes</strong>, but only if modifications have the same license.
        </label>
        <label for="cc_noderivatives">
            <input id="cc_noderivatives" type="radio" name="modification" value="noderivatives" />
            <strong>No</strong>, remixing is prohibited.
        </label>
    </fieldset>

    <fieldset>
        <legend>
            Is using the video for commercial purposes allowed ?
        </legend>
        <label for="cc_commercial">
            <input id="cc_commercial" type="radio" name="commercial" value="commercial" />
            <strong>Yes</strong>, commercial use is allowed.
        </label>
        <label for="cc_noncommercial">
            <input id="cc_noncommercial" type="radio" name="commercial" value="noncommercial" />
            <strong>No</strong>, commercial use is prohibited.
        </label>
    </fieldset>

    <div>
        <label for="file">file</label>
        <input id="file" name="file" type="file"/>
    </div>

    <div>
        <input name="commit" type="submit" value="Upload"/>
    </div>

</form>
