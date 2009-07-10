# Get basic information
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set admin_p [dotlrn::user_can_admin_community_p \
        -user_id $user_id \
        -community_id $community_id
]

if {[dotlrn_community::member_p $community_id $user_id] || $admin_p} {
    set member_p 1
} else {
    set member_p 0
}
set block_view_p [planner::enabled_p -community_id $community_id]
set mode [planner::get_mode -community_id $community_id]
if {[string equal $mode "topics"]} {
    set mode_msg [_ planner.blocks_topic]
} else {
    set mode_msg [_ planner.blocks_week]
}
set edit_p [ad_get_cookie blocks_edit_mode 0]
set last_block_id 0
set prev_object_id 0
set next_object_id 0
set inside_block_object_p 0
set get_next_object_p 0
set block_count 0
if { $block_view_p == "t" && $community_id ne "" && $member_p == 1 } {
    set blocks_info [planner::get_blocks_navigation_info -community_id $community_id]
    if { $planner_object_id > 0 } {
        foreach object $blocks_info {
            array set tmp_array $object
            if { $inside_block_object_p } {
                set next_object_id $tmp_array(object_id)
                break
            }
            if { $planner_object_id == $tmp_array(object_id) } {
                set inside_block_object_p 1
            } else {
                set prev_object_id $tmp_array(object_id)
            }
        }
    }
    template::util::list_to_multirow get_blocks $blocks_info
}
