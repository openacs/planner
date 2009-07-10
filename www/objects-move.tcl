ad_page_contract {
    Move an object inside a block in the community

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {to_block_id 0}
    {block_object_id 0}
    {tmp_block_object_id 0}
    {tmp_object_index 0}
    {return_url ""}
    {to_block 0}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

#get the next available index for the block 
# If object is moved to the last position, to_block = 1
# If that block has no objects => to prevent possible errors between info in DOM and DB on simultaneous editing
# If tmp_block_index is not the correct one in the DB => to prevent possible errors between info in DOM and DB on simultaneous editing
if { $to_block == 1 || [planner::count_block_objects -block_id $to_block_id] == 0 || [planner::get_block_id -block_object_id $tmp_block_object_id] != $to_block_id } {
    set to_block 1
    set tmp_object_index [planner::get_next_object_index -block_id $to_block_id]
} else {
    set tmp_object_index [planner::get_object_index -block_object_id $tmp_block_object_id]
}
# param: to_block => if the destination is the last position of a block = 1 otherwise = 0
if { $to_block_id != 0 && $block_object_id != 0 } {
    if { [db_0or1row get_object_info { *SQL* }] } {
        db_transaction {
            if { $block_id == $to_block_id } {
                # Move the object inside the same block
                if { $tmp_object_index > $object_index } {
                    db_dml move_object_down { *SQL* }
                    set tmp_object_index [expr $tmp_object_index - 1]
                } elseif { $tmp_object_index < $object_index } {
                    db_dml move_object_up { *SQL* }
                }
            } else {
                # Move the object to another block
                if { $to_block == 0 } {
                    db_dml update_objects_in_target_block { *SQL* }
                }
                db_dml update_objects_in_source_block { *SQL* }
            }
            db_dml update_object_info { *SQL* }
        }
    }
}

if {![empty_string_p $return_url]} {
    ad_returnredirect $return_url
}