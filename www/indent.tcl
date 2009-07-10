ad_page_contract {
    Indent an object inside a block in the community

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_object_id 0}
    {indent 0}
    {return_url ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set block_id [planner::get_block_id -block_object_id $block_object_id]
if { $indent != 0 && $block_object_id != 0 } {
    set spaces [db_string get_object_indent { *SQL* } -default 0]
    set spaces [expr $spaces + $indent]
    set parent_spaces [db_string get_parent_indent {} -default 0]
    if { [expr $parent_spaces + 5] >= $spaces || $indent < 0} {
        if { $spaces >= 0 } {
            db_transaction {
                db_dml update_object_indent { *SQL* }
            }
        }
    }
}

ad_returnredirect "$return_url#block_$block_id"