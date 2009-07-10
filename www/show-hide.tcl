ad_page_contract {
    Show/Hide a block in the community

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_id 0}
    {display_p "t"}
    {return_url "#block_$block_id"}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id
set block_index [planner::get_block_index -block_id $block_id]
if { $block_id != 0 && $block_index != 0 } {

    db_transaction {
        db_dml blocks_show_hide { *SQL* }
    }

}

ad_returnredirect $return_url