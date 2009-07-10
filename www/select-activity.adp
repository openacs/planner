<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
<link media="all" href="/resources/planner/select-activity.css" type="text/css" rel="stylesheet"/>
<!--[if IE 6]>
<link media="all" href="/resources/planner/select-activity-ie6.css" type="text/css" rel="stylesheet"/>
<![endif]-->
<script src="/resources/planner/select-activity.js" type="text/javascript"></script>
<center>
<table id="activities-select-table">
<tr>
    <td id="activities-left" valign="top">
        <div class="portlet-wrapper">
            <div class="bportlet_head_text">
                1. #planner.blocks_select_type_of_activity#
            </div>
            <div class="bcontslide"><br />
                <center>
                    <table id="activities-div">
                        <tr id="forums">
                            <td id="forums_loading" class="icon-spot"></td>
                            <td class="activities-icon"><!-- img src="" / --></td>
                            <td><a onclick="show_activities('get-activities?activity=forums&parent_id=@parent_id@','forums');">#forums.Forum#</a></td>
                            <td id="forums_ok" class="icon-spot"></td>
                        </tr>
                        <tr id="as_assessments">
                            <td id="as_assessments_loading" class="icon-spot"></td>
                            <td class="activities-icon"><!-- img src="" / --></td>
                            <td><a onclick="show_activities('get-activities?activity=as_assessments&parent_id=@parent_id@','as_assessments');">#assessment.Assessment#</a></td>
                            <td id="as_assessments_ok" class="icon-spot"></td>
                        </tr>
                        <tr id="evaluation_tasks">
                            <td id="evaluation_tasks_loading" class="icon-spot"></td>
                            <td class="activities-icon"><!-- img src="" / --></td>
                            <td><a onclick="show_activities('get-activities?activity=evaluation_tasks&parent_id=@parent_id@','evaluation_tasks');">#dotlrn-evaluation.Evaluation_#</a></td>
                            <td id="evaluation_tasks_ok" class="icon-spot"></td>
                        </tr>
                        <tr id="web_pages">
                            <td id="web_pages_loading" class="icon-spot"></td>
                            <td class="activities-icon"><!-- img src="" / --></td>
                            <td><a onclick="show_activities('get-activities?activity=web_pages&parent_id=@parent_id@','web_pages');">#planner.blocks_web_page#</a></td>
                            <td id="web_pages_ok" class="icon-spot"></td>
                        </tr>
                        <tr id="text_pages">
                            <td id="text_pages_loading" class="icon-spot"></td>
                            <td class="activities-icon"><!-- img src="" / --></td>
                            <td><a onclick="show_activities('get-activities?activity=text_pages&parent_id=@parent_id@','text_pages');">#planner.blocks_text_page#</a></td>
                            <td id="text_pages_ok" class="icon-spot"></td>
                        </tr>
			<if @chat_p@ eq 1>
                        <tr id="chat_rooms">
                            <td id="chat_rooms_loading" class="icon-spot"></td>
                            <td class="activities-icon"><!-- img src="" / --></td>
                            <td><a onclick="show_activities('get-activities?activity=chat_rooms&parent_id=@parent_id@','chat_rooms');">#chat.chat_rooms#</a></td>
                            <td id="chat_rooms_ok" class="icon-spot"></td>
                        </tr>
			</if>
                    </table>
                </center>
            </div>
        </div>
        <center><a href="@return_url;noquote@" class="button">#planner.Cancel#</a></center>
    </td>
    <td id="activities-center" valign="top">
    <div id="select_activity" style="display: none;">
        <table style="width: 100%;"><tr><td valign="top" class="arrow-td">
            <img src="/resources/content-portlet/images/grey_arrow.gif"/>
        </td><td>
            <div class="portlet-wrapper">
                <div class="bportlet_head_text">
                    2. #planner.blocks_choose_activity#
                </div><br />
                <div class="bcontslide" id="show_activities">
                </div>
            </div>
        </td></tr>
        </table>
    </div>
    </td>
    <td id="activities-right" valign="top">
     <div id="ok_submit" style="display: none;">
        <table style="width: 100%;"><tr><td valign="top" class="arrow-td">
            <img src="/resources/content-portlet/images/grey_arrow.gif"/>
        </td><td>
            <div class="portlet-wrapper">
                <div class="bportlet_head_text">
                    3. #planner.Confirm#
                </div>
                <div class="bcontslide">
                    <center>
                    <formtemplate id="activities"></formtemplate>
                    </center>
                </div>
            </div>
        </td></tr>
        </table>
    </div>
    </td>
</tr>
</table>
</center>
