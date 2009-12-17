<master>
  <property name="title">@title;noquote@</property>
  <property name="portal_page_p">1</property>
  <property name="blocks_edit_mode">@edit_mode@</property>

<link media="all" href="/resources/planner/view.css" type="text/css" rel="stylesheet"/>
<!--[if IE 6]>
<link media="all" href="/resources/planner/view-ie6.css" type="text/css" rel="stylesheet"/>
<![endif]-->
<!--[if IE 7]>
<link media="all" href="/resources/planner/view-ie.css" type="text/css" rel="stylesheet"/>
<![endif]-->
<link media="all" type="text/css" href="/resources/planner/navbar.css" rel="stylesheet">
<link media="all" type="text/css" href="/resources/calendar/calendar.css" rel="stylesheet">
<div id="bar" style="float:left;width:210px"><br/>
  <include src="/packages/planner/lib/navbar">
</div>
<div id="blocks" style="min-width: 550px;float:left;width:65%">
<if @admin_p@>
<div id="edit-mode" style="float: right; height: 21px; font-size: 10px; margin-right: 10px; padding-top: 12px; display: inline;">
    <a href="course-edit">#planner.blocks_course_settings#</a> 
        &nbsp;&nbsp;#planner.blocks_edit_mode# 
        <if @edit_p@ eq 1> <b>#planner.blocks_ON#</b> / <a href="?edit_p=0">#planner.blocks_OFF#</a> </if><else> <a href="?edit_p=1">#planner.blocks_ON#</a> / <b>#planner.blocks_OFF#</b> </else>
</div>
</if>
<if @admin_p@ eq 1>
    <if @get_blocks:rowcount@ eq 1 and @first_block_objects@ eq 0>
    <div id="blocks_info_message" style="margin-left: 2%;"><font size="3"><b>#planner.blocks_info_message#</b></font></div>
    </if>
</if>
<ul id="blocklist0" class="simple-list">
<multiple name="get_blocks">
<if @get_blocks.changed_p@ eq 1>
<li id="blockli_@get_blocks.block_id;noquote@" class="blocklist-li">
    <div id="block_@get_blocks.block_id;noquote@" class="portlet-wrapper"><div id="div_@get_blocks.block_id;noquote@">
        <div class="portlet-header">
            <div class="portlet-title">
            <h1>
                <if @get_blocks.block_index@ ne 0>
                    <if @dates@ ne 1><font size="3.5"><b id="block_index_@get_blocks.block_id@">@get_blocks.block_index@</b></font></if>
                    <if @dates@ eq 1><span id="block_date_@get_blocks.block_id@">@get_blocks.block_label;noquote@</span></if>
                    <if @admin_p@ ne 1 and @get_blocks.block_display@ eq "f"><span>(#planner.blocks_not_available#)</span></if>
                </if>
            </h1>
            </div>
            <div class="portlet-controls">
                <img height="16" width="19" alt="" src="/resources/theme-zen/images/global/trans.gif"/>
            </div>
        </div>
        <div class="portlet">
            <table class="table"><tr>
                <if @edit_p@ eq 1 and @admin_p@ eq 1>
                    <td id="move_block_@get_blocks.block_id@" rowspan="2" class="block-border @get_blocks.block_class@" style="vertical-align: top;">
                </if>
                <else>
                    <td id="move_block_@get_blocks.block_id@" rowspan="2" class="block-border" style="vertical-align: top;">
                </else>
                </td>
                <td>
                <if @get_blocks.summary@ ne ""><if @admin_p@ eq 1 or @get_blocks.block_display@ eq "t">@get_blocks.summary;noquote@</if></if>
                <if @edit_p@ eq 1><a href="summary?block_id=@get_blocks.block_id@">
                    <img title="#planner.blocks_edit_block_summary#" src="/resources/acs-subsite/Edit16.gif" /></a>
                </if>
                <br /><br />
                <if @edit_p@ eq 1>
                    <ul id="blocklist_@get_blocks.block_id@" class="simple-list minh25" rel="@get_blocks.block_display@">
                </if><else>
                    <ul id="blocklist_@get_blocks.block_id@" class="simple-list" rel="@get_blocks.block_display@">
                </else>
</if>
<if @get_blocks.object_name@ ne "">
<if @admin_p@ eq 1 or @get_blocks.block_display@ eq "t">
<if @admin_p@ eq 1 or @get_blocks.object_display@ eq "t">
    <if @move_id@ ne @get_blocks.block_object_id@>
        <if @edit_p@ eq 1 and @move_id@ gt 0>
            <li><a title="#planner.blocks_move_object_to_this_location#" href="objects-move?to_block=0&tmp_object_index=@get_blocks.object_index@&block_object_id=@move_id@&to_block_id=@get_blocks.block_id@&return_url=@community_url;noquote@planner/#block_@get_blocks.block_id@">
                    <img src="/resources/planner/move_arrow.gif" /></a></li>
        </if>
        <if @get_blocks.object_display@ eq "t" and @get_blocks.block_display@ eq "t">
            <li id="blockobject_@get_blocks.block_object_id@" class="block-li" rel="@get_blocks.object_display@">
        </if><else>
            <li id="blockobject_@get_blocks.block_object_id@" class="object-hidden block-li" rel="@get_blocks.object_display@">
        </else>
        <if @get_blocks.indent@ gt 0>
            <img src="/resources/planner/dot.gif" width="@get_blocks.indent@" height="12" />
        </if>
        <if @get_blocks.object_id@ ne 0>
            <a href="/o/@get_blocks.object_id@" target="@get_blocks.link_target@">
		<!-- img @get_blocks.image_specs@ src="@get_blocks.object_image;noquote@" / --> 
		@get_blocks.object_name;noquote@</a>
        </if>
        <else>
            @get_blocks.object_name;noquote@
        </else>
        <if @edit_p@ eq 1 and @admin_p@ eq 1>
            <if @get_blocks.indent@ gt 0>
                <a title="#planner.blocks_move_left#" href="indent?block_object_id=@get_blocks.block_object_id@&indent=-1">
                    <img src="/resources/planner/left.gif" /></a>
            </if>
            <a title="#planner.blocks_move_right#" href="indent?block_object_id=@get_blocks.block_object_id@&indent=1"><img src="/resources/planner/right.gif" /></a>
            <if @get_blocks.object_display@ eq "t" and @get_blocks.block_display@ eq "t">
                <a title="#planner.blocks_hide_from_students#" href="objects-show-hide?block_object_id=@get_blocks.block_object_id@&display_p=f">
                    <img src="/resources/planner/eye.gif" /></a>
            </if>
            <else>
                <a title="#planner.blocks_show_to_students#" href="objects-show-hide?block_object_id=@get_blocks.block_object_id@&display_p=t">
                    <img src="/resources/planner/eye_gray.gif" /></a>
            </else>
            <b id="move_object_@get_blocks.block_object_id@" title="#planner.blocks_move#" class="blocks-move">
                <img src="/resources/planner/move.gif" /></b>
            <a title="#planner.blocks_edit#" href="object-edit?block_object_id=@get_blocks.block_object_id@">
                <img src="/resources/acs-subsite/Edit16.gif" /></a>
            <a title="#planner.blocks_delete#" href="object-delete?block_object_id=@get_blocks.block_object_id@">
                <img src="/resources/acs-subsite/Delete16.gif" /></a>
        </if>
        </li>
    </if>
</if>
</if>
</if>
<if @admin_p@ eq 1>
    <if @get_blocks.count@ eq 0>
        <li></li><li></li>
    </if>
</if>
<if @get_blocks.last_p@ eq 1>
        <if @edit_p@ eq 1 and @move_id@ gt 0>
            <li><a title="#planner.blocks_move_object_to_this_location#" href="objects-move?to_block=1&block_object_id=@move_id@&to_block_id=@get_blocks.block_id@&return_url=@community_url;noquote@planner/">
                <img src="/resources/planner/move_arrow.gif" /></a></li>
        </if>
        </ul></td>
        <if @edit_p@ eq 1 and @admin_p@ eq 1>
            <td id="move_block2_@get_blocks.block_id@" rowspan="2" class="move block-border @get_blocks.block_class@">
        </if>
        <else>
            <td id="move_block2_@get_blocks.block_id@" rowspan="2" class="block-border">
        </else>
            <if @edit_p@ eq 1 and @admin_p@ eq 1>
                <if @get_blocks.block_index@ gt 0>
                    <if @get_blocks.block_display@ eq "t">
                        <a title="#planner.blocks_hide_from_students#" href="show-hide?display_p=f&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@planner/#block_@get_blocks.block_id@"><img src="/resources/planner/eye.gif" /></a><br />
                    </if>
                    <else>
                        <a title="#planner.blocks_show_to_students#" href="show-hide?display_p=t&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@planner/#block_@get_blocks.block_id@"><img src="/resources/planner/eye_gray.gif" /></a><br />
                    </else>
                    <if @get_blocks.block_index@ gt 1>
                        <a title="#planner.blocks_move_up#" href="move?move_to=up&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@planner/#block_@get_blocks.block_id@"><img src="/resources/planner/up.gif" /></a><br />
                    </if>
                    <if @get_blocks.rownum@ ne @get_blocks:rowcount@>
                        <a title="#planner.blocks_move_down#" href="move?move_to=down&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@planner/#block_@get_blocks.block_id@"><img src="/resources/planner/down.gif" /></a>
                    </if>
                </if>
            </if>
        </td></tr>
        <tr><td style="text-align: right;" valign="bottom">
            <if @edit_p@ eq 1 and @admin_p@ eq 1>
                <a href="@community_url;noquote@planner/select-activity?block_id=@get_blocks.block_id@&return_url=./index#block_@get_blocks.block_id@">#planner.blocks_add_existing_activity#...</a>
                <form id="activity_form_@get_blocks.block_id;noquote@" method="get" action="./">
                    <select id="resource_select" onchange="window.location = document.getElementById('activity_form_@get_blocks.block_id;noquote@').goto_r.options[document.getElementById('activity_form_@get_blocks.block_id;noquote@').goto_r.selectedIndex].value" name="goto_r">
                        <option value="javascript:void(0)">#planner.blocks_add_resource#...</option>
                        <option value="@community_url;noquote@planner/label?block_id=@get_blocks.block_id@">#planner.blocks_label#</option>
                        <option value="@xowiki_package_url;noquote@?object%5ftype=%3a%3axowiki%3a%3aPage&edit%2dnew=1&autoname=0&block_id=@get_blocks.block_id@">#planner.blocks_web_page#</option>
                        <option value="@xowiki_package_url;noquote@?object%5ftype=%3a%3axowiki%3a%3aPlainPage&edit%2dnew=1&block_id=@get_blocks.block_id@">#planner.blocks_text_page#</option>
                        <option value="@community_url;noquote@planner/file-mode?community_id=@community_id@&block_id=@get_blocks.block_id@&return_url=@fs_url;noquote@">#planner.blocks_link_to_file_web_folder#</option>
                        <if @learning_content_p@>
                        <optgroup label="#learning-content.content#">
                            <multiple name="content_categories">
                                <option value="@community_url;noquote@planner/object-add?block_id=@get_blocks.block_id@&object_id=@content_categories.category_id@" >@content_categories.category_name;noquote@</option>
                            </multiple>
                        </optgroup>
                        </if>
                    </select>
                    <select id="activity_select" onchange="window.location = document.getElementById('activity_form_@get_blocks.block_id;noquote@').goto_a.options[document.getElementById('activity_form_@get_blocks.block_id;noquote@').goto_a.selectedIndex].value" name="goto_a">
                        <option value="javascript:void(0)">#planner.blocks_add_activity#...</option>
                        <option value="@forums_url;noquote@admin/forum-new?block_id=@get_blocks.block_id@">#forums.Forum#</option>
                        <option value="@community_url;noquote@assessment/asm-admin/assessment-form?type=test&block_id=@get_blocks.block_id@">#assessment.Assessment#</option>
                        <if @chat_p@>
                          <option value="@chat_url;noquote@/room-edit">Add Chat Room</option>
                        </if>
                        <optgroup label="#dotlrn-evaluation.Evaluation_#">
                            <multiple name="get_grades">
                                <option value="@community_url;noquote@evaluation/admin/tasks/task-add-edit?block_id=@get_blocks.block_id@&grade_id=@get_grades.grade_id@&return_url=@community_url;noquote@/evaluation/admin?grade_id=@get_grades.grade_id@">@get_grades.grade_name;noquote@</option>
                            </multiple>
                        </optgroup>
                    </select>
                </form>
            </if>
        </td>
        </tr></table>
    </div>
</div></div>
</li>
<if @get_blocks.block_index@ eq 0>
    </ul><ul id="blocklist" class="simple-list">
</if>
</if>
</multiple>
</ul>
</div>

<if @admin_p@ eq 1>
    <script type="text/javascript" src="/resources/ajaxhelper/yui/yuiloader/yuiloader-beta-min.js"></script>
    <script type="text/javascript" src="/resources/ajaxhelper/yui/dom/dom-min.js"></script>
    
    <script type="text/javascript" src="/resources/ajaxhelper/yui/event/event-min.js"></script>
    <script type="text/javascript" src="/resources/ajaxhelper/yui/animation/animation-min.js"></script>
    <script type="text/javascript" src="/resources/ajaxhelper/yui/dragdrop/dragdrop-min.js"></script>
    <script type="text/javascript" src="/resources/ajaxhelper/yui/element/element-beta-min.js"></script>
    <script type="text/javascript" src="/resources/ajaxhelper/yui/button/button-min.js"></script>
    <script>
    var dates = '@dates@'
    var blocks_list = '@all_blocks@';
    var blocks_index_list = '@all_blocks_index@';
    var objects_list = '@all_objects@';
    var community_url = '@community_url;noquote@';
    var edit_mode = '@edit_p@';
    </script>
    <script type="text/javascript" src="/resources/planner/view.js"></script>
</if>