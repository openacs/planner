#
ad_page_contract {
    Interface for creating a new activity for content
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Apr 2008
 } {
        block_id
        {return_url "./"}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set page_title [_ planner.blocks_select_activity]
set context [list "$page_title"]

set package_id [ad_conn package_id]
set parent_id [site_node::get_node_id_from_object_id -object_id $package_id]

#check if chat is mounted, if not mount it
set community_url [dotlrn_community::get_community_url $community_id]
if {[site_node::exists_p -url "${community_url}chat"]} {
    set chat_p 1
} else {
    set chat_p 0
}

ad_form -name activities \
    -has_submit { 1 } \
    -export { block_id return_url } \
    -form {
        {activity_id:text(text),optional {label ""} {html {id "activity_id" value 0 style "display: none;"}}}
	{ok_submit:text(submit) {label "[_ planner.ok]"}}
    } -on_submit {
	set object_index [planner::get_next_object_index -block_id $block_id]
	planner::insert_object_to_block -block_id $block_id -object_id $activity_id -object_index $object_index
        ad_returnredirect "$return_url#block_$block_id"
    }

ah::requires -sources "scriptaculous"