ad_page_contract {
    Displays a community in blocks view

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {move_id "-1"}
    {edit_p "-1"}
}
# Get basic information
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
set admin_p [dotlrn::user_can_admin_community_p \
        -user_id $user_id \
        -community_id $community_id
]

if {[planner::enabled_p -community_id $community_id] != "t"} {
#    ad_returnredirect "./"
}

set title [dotlrn_community::get_community_name $community_id]

if { $admin_p } {
    if { $edit_p != "-1" } {
        ad_set_cookie blocks_edit_mode $edit_p
    } else {
        set edit_p [ad_get_cookie blocks_edit_mode 0]
    }
    set edit_mode 1
} else {
    set edit_mode 0
    set edit_p 0
}

set return_url [ad_conn url]
set package_id [dotlrn_community::get_package_id $community_id]
if { $admin_p } {
    #check if chat is mounted, if not mount it
    if {[site_node::exists_p -url "${community_url}chat"]} {
        set chat_p 1
    } else {
        set chat_p 0
    }
    if {[site_node::exists_p -url "${community_url}learning-content"]} {
        set learning_content_p 1
    } else {
        set learning_content_p 0
    }
    ah::requires -sources "scriptaculous"
    set ev_package_id [dotlrn_community::get_package_id_from_package_key -package_key evaluation -community_id $community_id]
    db_multirow get_grades get_grades_info { *SQL* } { }
    set fs_package_id [dotlrn_community::get_package_id_from_package_key -package_key file-storage -community_id $community_id]
    set fs_url [export_vars -base [apm_package_url_from_id $fs_package_id] {return_url}]
    set forums_package_id [dotlrn_community::get_package_id_from_package_key -package_key forums -community_id $community_id]
    set forums_url [apm_package_url_from_id $forums_package_id]
    if { $learning_content_p } {
        set content_package_url [lindex [site_node::get_children  -package_key "xowiki" -filters {name "learning-content"} -node_id [site_node::get_node_id_from_object_id -object_id $package_id]] 0]
        array set site_node [site_node::get_from_url -url $content_package_url]
        set content_package_id $site_node(package_id)
    }
#    set xowiki_package_url [lindex [site_node::get_children -package_key "xowiki" -filters {name "pages"} -node_id [site_node::get_node_id_from_object_id -object_id $package_id]] 0]
    set xowiki_package_url "${community_url}pages/"
    set fs_folder_id [fs::get_root_folder -package_id $fs_package_id]
    set fs_file_return_url [export_vars -base "${fs_url}file-add" {{folder_id $fs_folder_id} {block_id ""}}]
    set fs_file_url [export_vars -base "${fs_url}file-upload-confirm" {{cancel_url $return_url} {folder_id $fs_folder_id} {return_url $fs_file_return_url}}]
    set fs_link_url [export_vars -base "${fs_url}simple-add" {{folder_id $fs_folder_id}}]
    set fs_folder_url [export_vars -base "${fs_url}folder-create" {{parent_id $fs_folder_id}}]
    set chat_package_id [dotlrn_community::get_package_id_from_package_key -package_key chat -community_id $community_id]
    set chat_url [apm_package_url_from_id $chat_package_id]
}
set display_mode [planner::get_mode -community_id $community_id]
# Possible modes are -weeks- or -topics-
if { [string equal $display_mode "weeks"] } {
    set dates 1
} else {
    set dates 0
}
set last_block_id 0
set cont 0
set container_id 0
set block_count 0

if { $admin_p } {
    set blocks_info [planner::get_blocks_admin_info_not_cached -community_id $community_id]
    template::util::list_to_multirow get_blocks [lindex $blocks_info 0]
    set blocks_list [lindex $blocks_info 1]
    set blocks_index_list [lindex $blocks_info 2]
    set objects_list [lindex $blocks_info 3]
    set first_block_objects [lindex $blocks_info 4]
    
    # blocks list, blocks indexes list and objects list for Drag 'n' Drop 
    set all_blocks [join $blocks_list ","]
    set all_blocks_index [join $blocks_index_list ","]
    set all_objects [join $objects_list ","]

    if { $learning_content_p } {    
        set all_categories [planner::get_content_categories -content_package_id $content_package_id]
        template::util::list_to_multirow content_categories $all_categories
    }
} else {
    set blocks_info [planner::get_blocks_info_not_cached -community_id $community_id]
    template::util::list_to_multirow get_blocks $blocks_info
}