<if @object_info_p@ eq 1>
    <if @indent@ gt 0>
        <img src="/resources/planner/dot.gif" width="@indent@" height="12" />
    </if>
    <if @object_id@ ne 0>
        <a href="/o/@object_id@"><!-- img @image_specs@ src="@object_image;noquote@" / --> @object_name;noquote@</a>
    </if>
    <else>
        @object_name;noquote@
    </else>
    <if @indent@ gt 0>
        <a title="#planner.blocks_move_left#" href="indent?block_object_id=@block_object_id@&indent=-1">
            <img src="/resources/planner/left.gif" /></a>
    </if>
    <a title="#planner.blocks_move_right#" href="indent?block_object_id=@block_object_id@&indent=1"><img src="/resources/planner/right.gif" /></a>
    <if @object_display@ eq "t" and @block_display@ eq "t">
        <a title="#planner.blocks_hide_from_students#" href="objects-show-hide?block_object_id=@block_object_id@&display_p=f">
            <img src="/resources/planner/eye.gif" /></a>
    </if>
    <else>
        <a id="show-@block_object_id@" title="#planner.blocks_show_to_students#" href="objects-show-hide?block_object_id=@block_object_id@&display_p=t">
            <img src="/resources/planner/eye_gray.gif" /></a>
    </else>
    <b id="move_object_@block_object_id@" title="#planner.blocks_move#" class="move">
        <img src="/resources/planner/move.gif" /></b>
    <a title="#planner.blocks_edit#" href="object-edit?block_object_id=@block_object_id@">
        <img src="/resources/acs-subsite/Edit16.gif" /></a>
    <a title="#planner.blocks_delete#" href="object-delete?block_object_id=@block_object_id@">
            <img src="/resources/acs-subsite/Delete16.gif" /></a>
</if>