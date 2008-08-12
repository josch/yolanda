<%inherit file="base.mako"/>

<%def name="title()">
    results for "${c.query}"
</%def>

<%def name="heading()">
    There are over 9000 videos matching "${c.query}".
</%def>

<%def name="results_listing(results)">
    <ol id="results">
    % for result in c.results:
        <li>
            <a href="${h.url_for('video_page', video=result)}">
                <img src="${result['thumbnail']}" alt='thumbnail for "${result['title']}"'/>
            </a>
            <br />
            <a href="${h.url_for('video_page', video=result)}" class="title">
                ${result['title']}
            </a>
        </li>
    % endfor
    </ol>
</%def>

${results_listing(c.results)}
