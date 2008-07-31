<%inherit file="base.mako"/>

<%def name="title()">
    results for "${c.query}"
</%def>

<%def name="heading()">
    9001 results for "${c.query}":
</%def>

<%def name="results_listing(results)">
    <ol id="results">
    % for result in c.results:
        <li id="result">
            <a href="${h.url_for('video_page', video=result)}">
                <img src="${result['thumbnail']}" alt='thumbnail for "${result['title']}"'/>
            </a>
            <br />
            <a href="${h.url_for('video_page', video=result)}">
                ${result['title']}
            </a>
        </li>
    % endfor
    </ol>
</%def>

${results_listing(c.results)}
