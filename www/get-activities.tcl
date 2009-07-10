ad_page_contract {
    Get the existing applications for content activities

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Apr 2008
 } {
    {activity ""}
    {parent_id 0}
}

set result ""
set prev_forum_id 0
set prev_grade_item_id 0
set cont 0
set community_package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

switch $activity {
    "forums" {
        set activity_type "forums"
        set package_id [dotlrn_community::get_package_id_from_package_key -package_key $activity_type -community_id $community_id]
        db_multirow forums get_forums { *SQL* } {}
    }
    "as_assessments" {
        set activity_type "assessment"
        set package_id [dotlrn_community::get_package_id_from_package_key -package_key $activity_type -community_id $community_id]
        set folder_id [as::assessment::folder_id -package_id $package_id]
        db_multirow -extend { as_title } assessments get_as_item { *SQL* } {
            set as_title [db_string get_as_title {} -default ""]
        }
    }
    "evaluation_tasks" {
        set activity_type "evaluation"
        set package_id [dotlrn_community::get_package_id_from_package_key -package_key $activity_type -community_id $community_id]
        db_multirow -extend { changed_p count } evaluations get_grades_with_info { *SQL* } {
            if { $prev_grade_item_id == 0 } {
                set changed_p 1
            } elseif { $prev_grade_item_id != $grade_item_id } { 
                set changed_p 1
            } else {
                set changed_p 0
            }
            set prev_grade_item_id $grade_item_id
            set count $cont
            incr cont
        }
    }
    "web_pages" {
        array set node [site_node::get_from_url -url "${community_url}pages/"]
        set package_id $node(package_id)
        set folder_id [content::folder::get_folder_from_package -package_id $package_id]
        db_multirow web_pages get_web_pages { *SQL* } {}
    }
    "text_pages" {
        array set node [site_node::get_from_url -url "${community_url}pages/"]
        set package_id $node(package_id)
        set folder_id [content::folder::get_folder_from_package -package_id $package_id]
        db_multirow text_pages get_text_pages { *SQL* } {}
    }
    "chat_rooms" {
        set activity_type "chat"
        set package_id [dotlrn_community::get_package_id_from_package_key -package_key $activity_type -community_id $community_id]
        db_multirow chat_rooms get_chat_rooms { *SQL* } {}
    }
}

