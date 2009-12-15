<if @member_p@ eq 1>
<if @community_id@ ne "" and @block_view_p@ eq "t">
    <div id="blocks-navigation" style="float: right; font-size: 10px; margin-right: 10px; margin-top: 0px; display: inline;">
        <form id="blocks_activities" method="get" action="./">
            <if @inside_block_object_p@ eq 1 and @prev_object_id@ ne 0>
                <a href="/o/@prev_object_id@"><img width="18" height="18" src="/resources/dotlrn/left_nav.gif" /></a>
            </if>
            <select id="activity_select" onchange="window.location = document.getElementById('blocks_activities').goto.options[document.getElementById('blocks_activities').goto.selectedIndex].value" name="goto">
                <if @inside_block_object_p@ eq 0>
                    <option value="">#planner.blocks_go_to#</option>
                </if>
                <option value="../">#dotlrn.class_page_home_title#</option>
                <multiple name="get_blocks">
                    <if @get_blocks.changed_p@ eq 1 and @get_blocks.block_index@ ne 0>
                        <if @admin_p@ eq 1 or @get_blocks.block_display@ eq t>
                            <optgroup label="@mode_msg;noquote@ @get_blocks.block_index@">
                        </if>
                    </if>
                    <if @admin_p@ eq 1 or @get_blocks.block_display@ eq t>
                        <if @admin_p@ eq 1 or @get_blocks.object_display@ eq t>
                            <if @get_blocks.object_id@ eq @planner_object_id@>
                                <option value="/o/@get_blocks.object_id@" selected="selected">@get_blocks.object_name;noquote@</option>
                            </if>
                            <else>
                                <option value="/o/@get_blocks.object_id@">@get_blocks.object_name;noquote@</option>
                            </else>
                        </if>
                    </if>
                    <if @get_blocks.last_p@ eq 0 and @get_blocks.block_index@ ne 0>
                        <if @admin_p@ eq 1 or @get_blocks.block_display@ eq t>
                            </optgroup>
                        </if>
                    </if>
                </multiple>
            </select>
            <if @inside_block_object_p@ eq 1 and @next_object_id@ ne 0>
                <a href="/o/@next_object_id@"><img width="18" height="18" src="/resources/dotlrn/right_nav.gif" /></a>
            </if>
        </form>
    </div>
</if>
</if>