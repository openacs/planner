ad_page_contract {
  Redirect to the delete action of an object

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_object_id 0}
    {return_url ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
# Permissions
dotlrn::require_user_admin_community \
        -user_id $user_id -community_id $community_id

set block_id [planner::get_block_id -block_object_id $block_object_id]
set object_id [planner::get_object_id -block_object_id $block_object_id]
set object_type [acs_object_type $object_id]
set revision_id $object_id

if {[string eq $object_type content_item]} {
    set object_type [content::item::get_content_type -item_id $object_id]
    if {![string eq $object_type content_extlink]} {
        set revision_id [content::item::get_best_revision -item_id $object_id]
    }
}

db_dml delete_block_object { *SQL* }

## This next code is for delete the object from the DB
## Now the object is removed from the block but not from the DB
#if { [db_string check_object {} -default 0] == 0 } {
#    set page_url [lindex [callback -catch \
#        -impl $object_type planner::delete_url -object_id $revision_id] 0]
#    if {![empty_string_p $page_url]} {
#        ad_returnredirect [export_vars \
#            -base $page_url {{return_url $community_url}}]
#    }
#}

ad_returnredirect "$return_url\#block_$block_id"