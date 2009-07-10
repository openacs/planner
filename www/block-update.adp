<multiple name="get_blocks">
    <if @get_blocks.block_index@ gt 0>
        <if @get_blocks.block_display@ eq "t">
            <a title="#planner.blocks_hide_from_students#" href="show-hide?display_p=f&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@view#block_@get_blocks.block_id@"><img src="/resources/planner/eye.gif" /></a><br />
        </if>
        <else>
            <a title="#planner.blocks_show_to_students#" href="show-hide?display_p=t&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@view#block_@get_blocks.block_id@"><img src="/resources/planner/eye_gray.gif" /></a><br />
        </else>
        <if @get_blocks.block_index@ gt 1>
            <a title="#planner.blocks_move_up#" href="move?move_to=up&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@view#block_@get_blocks.block_id@"><img src="/resources/planner/up.gif" /></a><br />
        </if>
        <if @get_blocks.rownum@ ne @get_blocks:rowcount@>
            <a title="#planner.blocks_move_down#" href="move?move_to=down&block_id=@get_blocks.block_id@&return_url=@community_url;noquote@view#block_@get_blocks.block_id@"><img src="/resources/planner/down.gif" /></a>
        </if>
    </if>-----
</multiple>

