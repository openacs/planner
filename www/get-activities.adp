<table class="activities" style="width: 100%;">
<if @activity@ eq "forums">
    <if @forums:rowcount@ eq 0><tr><td> #planner.blocks_there_are_no_activities# </td></tr></if>
    <multiple name="forums">
        <tr id="activity_@forums.forum_id@">
            <td><a onclick="select_activity('@forums.forum_id@',0);">@forums.name@</a></td>
        </tr>
    </multiple>
</if>
<if @activity@ eq "as_assessments">
    <if @assessments:rowcount@ eq 0><tr><td> #planner.blocks_there_are_no_activities# </td></tr></if>
    <multiple name="assessments">
        <tr id="activity_@assessments.item_id@"><td><a onclick="select_activity('@assessments.item_id@',0);">@assessments.as_title@</a></td></tr>
    </multiple>
</if>
<if @activity@ eq "evaluation_tasks">
    <if @evaluations:rowcount@ eq 0><tr><td> #planner.blocks_there_are_no_activities# </td></tr></if>
    <multiple name="evaluations">
        <if @evaluations.changed_p@ eq 1>
            <tr id="activity_@evaluations.grade_id@">
                <th>@evaluations.grade_plural_name@</th>
            </tr>
        </if>
        <tr id="activity_@evaluations.task_item_id@"><td><a style="margin-left: 20px;" onclick="select_activity('@evaluations.task_item_id@',0);">@evaluations.task_name@</a></td></tr>
    </multiple>
</if>
<if @activity@ eq "text_pages">
    <if @text_pages:rowcount@ eq 0><tr><td> #planner.blocks_there_are_no_activities# </td></tr></if>
    <multiple name="text_pages">
        <tr id="activity_@text_pages.item_id@">
            <td><a onclick="select_activity('@text_pages.item_id@',0);">@text_pages.name@</a></td>
        </tr>
    </multiple>
</if>
<if @activity@ eq "web_pages">
    <if @web_pages:rowcount@ eq 0><tr><td> #planner.blocks_there_are_no_activities# </td></tr></if>
    <multiple name="web_pages">
        <tr id="activity_@web_pages.item_id@">
            <td><a onclick="select_activity('@web_pages.item_id@',0);">@web_pages.name@</a></td>
        </tr>
    </multiple>
</if>
<if @activity@ eq "chat_rooms">
    <if @chat_rooms:rowcount@ eq 0><tr><td> #planner.blocks_there_are_no_activities# </td></tr></if>
    <multiple name="chat_rooms">
        <tr id="activity_@chat_rooms.room_id@">
            <td><a onclick="select_activity('@chat_rooms.room_id@',0);">@chat_rooms.name@</a></td>
        </tr>
    </multiple>
</if>
</table>
