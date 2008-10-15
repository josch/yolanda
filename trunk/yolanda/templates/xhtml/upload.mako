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

    <ol>

        <li id="title">
            <label for="title">title</label>
            <input name="title" type="text"/>
        </li>

        <li id="alternative">
            <label for="alternative">alternative title</label>
            <input name="alternative" type="text"/>
        </li>

        <li id="abstract">
            <label for="abstract">abstract</label>
            <textarea name="abstract"/>
        </li>

        <li id="spatial">
            <label for="spatial">spatial</label>
            <input name="spatial" type="text"/>
        </li>

        <li id="subject">
            <label for="subject">subject</label>
            <input name="subject" type="text"/>
        </li>

        <li id="temporal">
            <label for="temporal">temporal</label>
            <input name="temporal" type="datetime"/>
        </li>

        <li id="language">
            <label for="language">language</label>
            <select name="language">
                <option value="de">German</option>
                <option value="en">English</option>
            </select>
        </li>

        <li>
            <label for="creator">creator</label>
            <input id="creator" name="creator" type="text"/>
        </li>

        <li>
            <div id="contributor" repeat="template">
                <label for="contributor">Contributor</label>
                <input name="contributor.[contributor]" type="text"/>
                <button type="remove">Remove</button>
            </div>
            <button type="add" template="contributor">Add contributor</button>
        </li>

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
        <li>
            <fieldset>
                <legend>
                    Remix ?
                </legend>
                <label for="remix">
                    <input id="remix" type="radio" name="modification" value="remix" />
                    remix
                </label>
                <label for="sharealike">
                    <input id="sharealike" type="radio" name="modification" value="sharealike" />
                    sharealike
                </label>
                <label for="noderivatives">
                    <input id="noderivatives" type="radio" name="modification" value="noderivatives" />
                    noderivatives
                </label>
            </fieldset>
        </li>

        <li>
            <fieldset>
                <legend>
                    Commercial ?
                </legend>
                <label for="commercial">
                    <input id="commercial" type="radio" name="commercial" value="commercial" />
                    commercial
                </label>
                <label for="noncommercial">
                    <input id="noncommercial" type="radio" name="commercial" value="noncommercial" />
                    noncommercial
                </label>
            </fieldset>
        </li>

        <li>
            <label for="file">file</label>
            <input id="file" name="file" type="file"/>
        </li>

        <li>
            <input name="commit" type="submit" value="Upload"/>
        </li>

    </ol>

</form>
