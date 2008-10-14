<%inherit file="base.mako"/>

<%def name="title()">
    front page
</%def>

<%def name="heading()">
    upload video
</%def>


        ${h.form(h.url_for(action='upload'), multipart=True)}
            ${h.file_field('file')}<br />
            ${h.text_field('title')}<br />
            ${h.submit('Upload')}

        ${h.end_form()}
