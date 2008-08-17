<%inherit file="base.mako"/>

<%def name="title()">
    front page
</%def>

<%def name="heading()">
    Upload Video
</%def>


        ${h.form(h.url_for(action='upload'), multipart=True)}
            ${h.file_field('file')}<br />
            ${h.text_field('name')}<br />
            ${h.submit('Upload')}

        ${h.end_form()}
