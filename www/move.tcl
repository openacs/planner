ad_page_contract {
    Move a block in the community, the tmp_block_id is the block_id
    of the next block in the list but when we are moving the block 
    to the last position we set last_p 1 and the tmp_block_id is the
    block_id of the previous block in the list

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_id 0}
    {tmp_block_id 0}
    {last_p 0}
    {return_url ""}
    {swap_p 1}
    {move_to ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set block_index [planner::get_block_index -block_id $block_id]
if {![empty_string_p $move_to]} {
    if {[string equal $move_to "up"]} {
        set tmp_block_id [db_string get_prev_block_id { *SQL* } -default 0]
    } elseif {[string equal $move_to "down"]} {
        set tmp_block_id [db_string get_next_block_id { *SQL* } -default 0]
    }
}

if { $tmp_block_id != 0 && $block_id != 0 } {
    set tmp_block_index [planner::get_block_index -block_id $tmp_block_id]
    if {$swap_p} {
        # Move a block to an adjacent position
        db_transaction {
            planner::update_block_index -block_id $block_id -block_index $tmp_block_index
            planner::update_block_index -block_id $tmp_block_id -block_index $block_index
        }
    } else {
        # Move a block to another position
        db_transaction {
            if { $last_p == 0 } {
                if { $tmp_block_index > $block_index } {
                    db_dml move_block_down { *SQL* }
                    set tmp_block_index [expr $tmp_block_index - 1]
                } elseif { $tmp_block_index < $block_index } {
                    db_dml move_block_up { *SQL* }
                }
            } else {
                if { $tmp_block_index != 0 } {
                    db_dml move_block_last { *SQL* }
                }
            }
            planner::update_block_index -block_id $block_id -block_index $tmp_block_index
        }
    }
}

if {![empty_string_p $return_url]} {
    ad_returnredirect $return_url
}