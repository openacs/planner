ad_page_contract {
    Return blocks order in the community

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_index1 0}
    {block_index2 0}
    {dates_p 0}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

if { $block_index1 > $block_index2 } {
    set first_block_index $block_index2
    set second_block_index $block_index1
} else {
    set first_block_index $block_index1
    set second_block_index $block_index2
}
set block_id_list [db_list get_ids { *SQL* }]
set block_ids [join $block_id_list ","]
set block_index_list [db_list get_indexes { *SQL* }]
set block_indexes [join $block_index_list ","]
set current_id 0

if { $dates_p == 1 } {
    set current_time [clock seconds]
    set start_time [planner::get_start_date -community_id $community_id]
    if { $start_time != 0 } {
        set start_time [clock scan $start_time]
    } else {
        set start_time $current_time
    }
    set block_date_list [list]
    foreach index $block_index_list bid $block_id_list {
        set offset [expr 7 * [expr $index - 1]]
        set start_clock [clock scan "$offset days" -base $start_time]
        set end_clock [clock scan "6 day" -base $start_clock]
        set dates [planner::get_block_dates -start_clock $start_clock]
        if { $current_time > $start_clock && $current_time < [clock scan "1 day" -base $end_clock] } {
            set current_id $bid
        }
        lappend block_date_list $dates
    }
    set block_names [join $block_date_list ","]
} else {
    set block_names $block_indexes
}