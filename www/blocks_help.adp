<style>
    body {
        font-size:13px;
    }
    #tutorials_help {
        font-size:10px;
    }
</style>
<div id="blocks_welcome_message">
#planner.blocks_info_message#
</div> <br>
<h2>#planner.blocks_tutorials#</h2>
<p id="tutorials_help">
<img border="0" height="9" width="12" src="/shared/images/info.gif" alt="[i]" title="Help text"/>
#planner.blocks_note#
</p>
<ul id="tutorials"> 
<li><a href="/resources/planner/tutorials/01.html">#planner.blocks_planner_configuration#</a></li>
<li><a href="/resources/planner/tutorials/02.html">#planner.blocks_add_activity#</a></li>
<li><a href="/resources/planner/tutorials/03.html">#planner.blocks_add_existing_activity#</a></li>
<li><a href="/resources/planner/tutorials/04.html">#planner.blocks_planner_organization#</a></li>
<li><a href="/resources/planner/tutorials/05.html">#planner.blocks_planner_navigation#</a></li>
</ul>
<script>
    var links = document.getElementsByTagName('a');
    for(i = 0; i < links.length; i++) {
	var a_link = links[i];
        a_link.onclick = function(){ resizeTo(650,600); }
    }
</script>
