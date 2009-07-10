ad_page_contract {
    Add an object to a block in the community

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_id 0}
    {object_id:multiple,integer}
    {return_url ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

if { $block_id == 0 } {
    set block_id [ad_get_cookie fs_block_id "$block_id"]
}

foreach object $object_id {
    set object_index [planner::get_next_object_index -block_id $block_id]
    planner::insert_object_to_block -block_id $block_id -object_id $object -object_index $object_index
}
ad_set_cookie fs_block_id 0
ad_set_cookie fs_web2 0
ad_set_cookie fs_community_id 0

ad_returnredirect "$return_url#block_$block_id"