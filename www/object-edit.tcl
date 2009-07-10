ad_page_contract {
    Redirect to the edit action of an object

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_object_id 0}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set object_id [planner::get_object_id -block_object_id $block_object_id]
set object_label [planner::get_label -block_object_id $block_object_id]
if { $object_id == 0 } {
    # It's a label object
    if {![empty_string_p $object_label]} {
        ad_returnredirect "label?block_object_id=$block_object_id"
    } else {
        ad_returnredirect ""
    }
}

set object_type [acs_object_type $object_id]

if {[string eq $object_type content_item]} {
    set object_type [content::item::get_content_type -item_id $object_id]
    if {![string eq $object_type content_extlink]} {
        set object_id [content::item::get_best_revision -item_id $object_id]
    }
}

if {[string eq $object_type apm_package]} {
    ad_returnredirect "[apm_package_url_from_id $object_id]admin/content-admin"
}

set page_url [lindex [callback -catch -impl $object_type planner::edit_url -object_id $object_id] 0]

if {![empty_string_p $page_url]} {
    ad_returnredirect [export_vars -base $page_url {{return_url $community_url}}]
} else {
    ad_returnredirect ""
}
