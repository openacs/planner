ad_page_contract {
    Enable/Disable Block View in a community

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {enable_p "f"}
    {return_url ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

planner::enable -community_id $community_id -enable_p $enable_p

if {![empty_string_p $return_url]} {
    ad_returnredirect $return_url
}