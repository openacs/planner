ad_library {

    Procs for Planner View in dotLRN

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-08

}

namespace eval planner {}

ad_proc -public planner::flush_blocks_cache {
    {-community_id:required}
    {-navigation_p 1}
} {
    Flush the blocks cache

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id Delete the cache of the specified community
    @param navigation_p Delete the cache for the navigation select
} {
    if { $navigation_p } {
        util_memoize_flush "planner::get_blocks_navigation_info_not_cached -community_id $community_id"
    }
    util_memoize_flush "planner::get_blocks_admin_info_not_cached -community_id $community_id"
    util_memoize_flush "planner::get_blocks_info_not_cached -community_id $community_id"
}

ad_proc -public planner::get_objects_names {
    {-community_id:required}
} {
    Returns an array with all the names from the objects in the blocks
    
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id The community id to get the blocks information
} {
    db_foreach get_object_types { *SQL* } {
        switch $object_type {
            "evaluation_tasks" {
                set object_type_query_name "get_tasks_name"
            }
            "file_storage_object" -
            "as_assessments" -
            "::xowiki::PlainPage" -
            "::xowiki::Page" {
                set object_type_query_name "get_items_name"
            }
            "content_extlink" {
                set object_type_query_name "get_links_name"
            }
            "chat_room" {
                set object_type_query_name "get_chat_rooms_name"
            }
            default {
                set object_type_query_name "get_objects_name"
            }
        }
        if {![string equal $object_type "category"]} {
            db_foreach $object_type_query_name { *SQL* } {
                set names($object_id) $name
            }
        } else {
            db_foreach $object_type_query_name { *SQL* } {
                set parent_id [category::get_parent -category_id $object_id]
                for {set i 0} { $parent_id != 0 && $i < 2 } { incr i } {
                    set category_id $parent_id
                    set name "[learning_content::get_category_name -category_id $parent_id]:$name"
                    set parent_id [category::get_parent -category_id $category_id]
                }
                set names($object_id) $name
            }
        }
    }
    return [array get names]
}

ad_proc -public planner::get_object_types_names {
    {-community_id:required}
} {
    Returns an array with all the pretty names from the object types in the blocks

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Feb-2009

    @param community_id The community id to get the blocks information
} {
    db_foreach get_object_types { *SQL* } {
        set object_types_names($object_type) [planner::get_object_type_pretty_name -object_type $object_type]
    }
    return [array get object_types_names]
}

ad_proc -public planner::get_content_categories {
    {-content_package_id:required}
} {
    Returns all the categories from the given learning-content instance
    
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param content_package_id The package id of the learning-content instance to get the categories
} {
    # get all content categories for the select
    # get the categories of the tree in the default locale, not the current one
    set locale "en_US"
    template::multirow -local create content_categories category_id category_name
    set trees [category_tree::get_mapped_trees $content_package_id]
    foreach tree $trees {
        set tree_id [lindex $tree 0]
        set units [db_list get_categories { *SQL* }]
        set tree_list [list]
        foreach unit_id $units {
            set category_list [list]
            if { [category::count_children -category_id $unit_id] } {
                set categories [category::get_children -category_id $unit_id]
                foreach category_id $categories {
                    set subcategory_list [list]
                    if { [category::count_children -category_id $category_id] } {
                        set subcategories [category::get_children -category_id $category_id]
                        foreach subcategory_id $subcategories {
                            if { [llength [category::get_objects -category_id $subcategory_id]] > 0 } {
                                set subcategory_name [learning_content::get_category_name -category_id $subcategory_id]
                                set subcategory_name "&nbsp;&nbsp;&nbsp;&nbsp;  $subcategory_name"
                                lappend subcategory_list $subcategory_id $subcategory_name
                            }
                        }
                    }
                    if { [llength [category::get_objects -category_id $category_id] ] || [llength $subcategory_list] > 0 } {
                        set category_name [learning_content::get_category_name -category_id $category_id]
                        set category_name "&nbsp;&nbsp; $category_name"
                        lappend category_list $category_id $category_name
                    }
                    foreach sub $subcategory_list { lappend category_list $sub }
                }
            }
            if { [llength [category::get_objects -category_id $category_id] ] || [llength $category_list] > 0 } {
                set unit_name [learning_content::get_category_name -category_id $unit_id]
                lappend tree_list $unit_id $unit_name
            }
            foreach cat $category_list { lappend tree_list $cat }
        }
        for {set i 0 } { $i < [llength $tree_list] } { set i [expr $i + 2] } {
            template::multirow -local append content_categories [lindex $tree_list $i] [lindex $tree_list [expr $i + 1]]
        }
    }
    return [template::util::multirow_to_list content_categories]
}

ad_proc -public planner::get_blocks_navigation_info {
    {-community_id:required}
} {
    Returns a list with two objects, the first one is an array with 
    the information about every object in the blocks of a given community 
    and the second one is an array with the information needed to display 
    the navigation (cached)

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id The community id to get the objects in the blocks
} {
    return [util_memoize [list planner::get_blocks_navigation_info_not_cached -community_id $community_id]]
}

ad_proc -public planner::get_blocks_navigation_info_not_cached {
    {-community_id:required}
} {
    Returns a list with two objects, the first one is an array with 
    the information about every object in the blocks of a given community 
    and the second one is an array with the information needed to display 
    the navigation (not cached)

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id The community id to get the objects in the blocks
} {
    set get_next_object_p 0
    set last_block_id 0
    set inside_block_object_p 0
    set next_object_id 0
    set prev_object_id 0
    set objects_names [planner::get_objects_names -community_id $community_id]
    array set names $objects_names
    db_multirow -local -extend { object_name changed_p selected_code last_p } get_blocks get_blocks_info {} {
        if { $get_next_object_p } {
            set next_object_id $object_id
            set get_next_object_p 0
        }
        set previous_block $last_block_id
        if { $last_block_id == $block_id } {
            set changed_p 0
            incr block_count
            if { $count == $block_count } {
                set last_p 1
            }
        } else {
            # If there's 1 or 0 objects in block, the block ends here
            if { $count == 0 || $count == 1 } { 
                set last_p 1
            }
            set block_count 1
            set changed_p 1
        }
        set last_block_id $block_id
        # If we are in a page that has a blocks_object_id set the navigation select for this object
        if { [exists_and_not_null blocks_object_id] && $blocks_object_id == $object_id } {
            set object_name "#planner.blocks_go_to#"
        } else {
            set selected_code ""
            set object_name $names($object_id)
            set object_name [string_truncate -len 50 $object_name]
        }
        set last_object_id $object_id
    }
    return [template::util::multirow_to_list get_blocks]
}

ad_proc -public planner::get_blocks_admin_info {
    {-community_id:required}
} {
    Returns a list with 5 objects, the first one is an array with the 
    information about every object in the blocks of a given community and the 
    rest are information needed to display the blocks (cached)

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id The community id to get the objects in the blocks for admins
} {
    return [util_memoize [list planner::get_blocks_admin_info_not_cached -community_id $community_id]]
}

ad_proc -public planner::get_blocks_admin_info_not_cached {
    {-community_id:required}
} {
    Returns a list with 5 objects, the first one is an array with the 
    information about every object in the blocks of a given community and the 
    rest are information needed to display the blocks (not cached)

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id The community id to get the objects in the blocks for admins
} {
    set current_time [clock seconds]
    set start_time [planner::get_start_date -community_id $community_id]
    if { $start_time != 0 } {
        set start_time [clock scan $start_time]
    } else {
        set start_time $current_time
    }
    set display_mode [planner::get_mode -community_id $community_id]
    # Possible modes are -weeks- or -topics-
    if { [string equal $display_mode "weeks"] } {
        set dates 1
    } else {
        set dates 0
    }
    #TODO: Add move_id as a proc param if the option to move blocks w/o ajax is enabled
    set move_id 0
    set blocks_list [list]
    set blocks_index_list [list]
    set objects_list [list]
    set multirow_extend [list changed_p object_name previous_block \
        block_label current_block_p block_class object_image \
        image_specs last_p link_target]
    set open_external_object_types [list "content_extlink" "file_storage_object"]
    set last_block_id 0
    set first_block_objects 0
    set last_class ""
    set objects_names [planner::get_objects_names -community_id $community_id]
    set object_types_names [planner::get_object_types_names -community_id $community_id]
    array set names $objects_names
    array set object_types $object_types_names
    # This multirow gets block_id and object_id, changed_p = 1 when we are
    # entering on a new block to draw the block frame in the adp
    db_multirow -local -extend $multirow_extend get_blocks get_blocks_admin_info { *SQL* } {
        if { $block_index == 0 } { set first_block_objects $count }
        if { ![empty_string_p $indent] } {
            set indent [expr {$indent * 20}]
        } else {
            set indent 0
        }
        if { $last_block_id == $block_id } {
            set changed_p 0
            incr block_count
            if { $count == $block_count } {
                set last_p 1
            }
            set block_class $last_class
        } else {
            # If there's 1 or 0 objects in block, the block ends here
            if { $count == 0 || $count == 1 } { 
                set last_p 1
            }
            # This is the first object of a new block, get the block information
            lappend blocks_list "$block_id"
            lappend blocks_index_list "$block_index"
            set changed_p 1
            set block_count 1
            # Blocks Names are for all blocks except the first one index = 0
            if { $dates == 1 && $block_index > 0 } {
                set start_clock $start_time
                set start_time [clock scan "6 days" -base $start_time]
                set end_clock $start_time
                set block_label [planner::get_block_dates -start_clock $start_clock]
                set start_time [clock scan "1 day" -base $start_time]
                set block_class ""
                if { $block_index > 0 && $block_display == "t" } {
                    if { $start_clock < $current_time && [clock scan "1 day" -base $end_clock] > $current_time && $dates == 1 } {
                        set current_block_p 1
                        set block_class "current-block"
                    } else {
                        set current_block_p 0
                    }
                } else {
                    if { $block_index != 0 } {
                        set block_class "hidden-block"
                    }
                }
            }
            if { ![empty_string_p $summary] } {
                set summary [lindex $summary 0]
            }
            set last_class $block_class
        }
        set last_block_id $block_id
        if {![empty_string_p $object_id]} {
            lappend objects_list "$block_object_id"
            if {$object_id != 0} {
                if {[lsearch -exact $open_external_object_types $object_type] != -1} {
                    set link_target "_blank"
                } else {
                    set link_target ""
                }
                set image_specs "width=16 height=16"
                set object_image [planner::get_object_icon -object_type $object_type]
                set object_type_name $object_types($object_type)
                set object_name $names($object_id)
                set object_name [string_truncate -len 100 $object_name]
            } else {
                set object_name [lindex $label 0]
            }
        } else {
            set object_name ""
        }
        if { $block_object_id == $move_id } {
            set container_id $block_id
            set move_name $object_name
            set object_name ""
        }
        append block_class " blocks-move"
    }
    return [list [template::util::multirow_to_list get_blocks] $blocks_list $blocks_index_list $objects_list $first_block_objects]
}

ad_proc -public planner::get_blocks_info {
    {-community_id:required}
} {
    Returns an array with the information about every 
    object in the blocks of a given community (cached)

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id The community id to get the objects in the blocks for admins
} {
    return [util_memoize [list planner::get_blocks_info_not_cached -community_id $community_id]]
}

ad_proc -public planner::get_blocks_info_not_cached {
    {-community_id:required}
} {
    Returns an array with the information about every 
    object in the blocks of a given community (not cached)

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jan-2009

    @param community_id The community id to get the objects in the blocks for admins
} {
    set current_time [clock seconds]
    set start_time [planner::get_start_date -community_id $community_id]
    if { $start_time != 0 } {
        set start_time [clock scan $start_time]
    } else {
        set start_time $current_time
    }
    set display_mode [planner::get_mode -community_id $community_id]
    # Possible modes are -weeks- or -topics-
    if { [string equal $display_mode "weeks"] } {
        set dates 1
    } else {
        set dates 0
    }
    set last_block_id 0
    set multirow_extend [list changed_p object_name \
        block_label current_block_p block_class object_image \
        image_specs last_p link_target]
    set open_external_object_types [list "content_extlink" "file_storage_object"]
    set objects_names [planner::get_objects_names -community_id $community_id]
    array set names $objects_names
    # This multirow gets block_id and object_id, changed_p = 1 when we are
    # entering on a new block to draw the block frame in the adp
    db_multirow -local -extend $multirow_extend get_blocks get_blocks_info { *SQL* } {
        if { $block_index == 0 } { set first_block_objects $count }
        if { ![empty_string_p $indent] } {
            set indent [expr {$indent * 20}]
        } else {
            set indent 0
        }
        if { $last_block_id == $block_id } {
            set changed_p 0
            incr block_count
            if { $count == $block_count } {
                set last_p 1
            }
        } else {
            # If there's 1 or 0 objects in block, the block ends here
            if { $count == 0 || $count == 1 } { 
                set last_p 1
            }
            set changed_p 1
            set block_count 1
            # This is the first object of a new block, get the block information
            # Blocks Names are for all blocks except the first one index = 0
            if { $dates == 1 && $block_index > 0 } {
                set start_clock $start_time
                set start_time [clock scan "6 days" -base $start_time]
                set end_clock $start_time
                set block_label [planner::get_block_dates -start_clock $start_clock]
                set start_time [clock scan "1 day" -base $start_time]
                set block_class ""
                if { $block_index > 0 && $block_display == "t" } {
                    if { $start_clock < $current_time && [clock scan "1 day" -base $end_clock] > $current_time && $dates == 1 } {
                        set current_block_p 1
                        set block_class "current-block"
                    } else {
                        set current_block_p 0
                    }
                } else {
                    if { $block_index != 0 } {
                        set block_class "hidden-block"
                    }
                }
            }
            if { ![empty_string_p $summary] } {
                set summary [lindex $summary 0]
            }
        }
        set last_block_id $block_id
        if {![empty_string_p $object_id]} {
            lappend objects_list "$block_object_id"
            if {$object_id != 0} {
                if {[lsearch -exact $open_external_object_types $object_type] != -1} {
                    set link_target "_blank"
                } else {
                    set link_target ""
                }
                set image_specs "width=16 height=16"
                set object_image [planner::get_object_icon -object_type $object_type]
                set object_name $names($object_id)
                set object_name [string_truncate -len 100 $object_name]
            } else {
                set object_name [lindex $label 0]
            }
        } else {
            set object_name ""
        }
    }
    return [template::util::multirow_to_list get_blocks]
}

ad_proc -public planner::get_next_object_index {
    {-block_id:required}
} {
    Gets the next object index to add a new object

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

    @param block_id The block to get the objects and check the indexes

} {
    set object_index [db_string get_max_index {} -default 0]
    if { [empty_string_p $object_index] } { set object_index 0 }
    incr object_index
    return $object_index	
}

ad_proc -public planner::insert_object_to_block {
    {-block_id:required}
    {-object_id:required}
    {-resource_type "object"}
    {-object_index:required}
    {-label_text ""}
    {-indent 0}
} {
    Gets the next object index to add a new object

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

    @param block_id The block to get the objects and check the indexes

} {
    set block_object_id [db_nextval blocks_objects_seq]
    db_dml insert_object_to_block {}
}

ad_proc -public planner::get_block_index {
    {-block_id:required}
} {
    Gets the index of a block inside a community

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set block_index [db_string get_block_index {} -default 0]
    return $block_index
}

ad_proc -public planner::get_object_index {
    {-block_object_id:required}
} {
    Gets the index of an object inside a block

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set object_index [db_string get_object_index {} -default 0]
    return $object_index
}

ad_proc -public planner::get_object_id {
    {-block_object_id:required}
} {
    Gets the object_id of an object inside a block

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set object_id [db_string get_object_id {} -default 0]
    return $object_id
}

ad_proc -public planner::get_label {
    {-block_object_id:required}
} {
    Gets the label of an object inside a block

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set label_text [db_string get_label {} -default ""]
    return $label_text
}

ad_proc -public planner::update_block_index {
    {-block_id:required}
    {-block_index:required}
} {
    Update the index of a block inside a community

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    db_dml update_block_index { *SQL* }
}

ad_proc -public planner::get_start_date {
    {-community_id:required}
} {
    Gets the start date of a community in Block View

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set start_date [db_string get_start_date {} -default 0]
    return $start_date
}

ad_proc -public planner::count_block_objects {
    {-block_id:required}
} {
    Gets the number of objects inside a block

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

    @param block_id The block to get the number of objects

} {
    set count [db_string count_block_objects {} -default 0]
    return $count
}

ad_proc -public planner::get_block_id {
    {-block_object_id:required}
} {
    Gets the id of the block containing the object

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set block_id [db_string get_block_id {} -default 0]
    return $block_id
}

ad_proc -public planner::get_community_id_from_block_id {
    {-block_id:required}
} {
    Get the community id based on the block_id
} {
    set community_id [db_string get_community_id { *SQL* } -default 0]
    return $community_id
}

ad_proc -public planner::get_mode {
    {-community_id:required}
} {
    Gets the mode of a community in Block View

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set mode [db_string get_mode {} -default "weeks"]
    return $mode
}

ad_proc -public planner::get_object_name {
    {-object_id:required}
    {-object_type:required}
} {
    Gets the name of an object depending on the object_type

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    switch $object_type {
        "evaluation_tasks" {
            set revision_id [content::item::get_best_revision -item_id $object_id]
            set object_name [db_string get_task_name {} -default ""]
        }
        "file_storage_object" -
        "as_assessments" -
        "::xowiki::PlainPage" -
        "::xowiki::Page" {
            set object_name [db_string get_item_name {} -default ""]
        }
        "chat_room" {
            set object_name [db_string get_chat_room_name {} -default ""]
        }
        "category" {
            set object_name [learning_content::get_category_name -category_id $object_id]
            set parent_id [category::get_parent -category_id $object_id]
            for {set i 0} { $parent_id != 0 && $i < 2 } { incr i } {
                set object_id $parent_id
                set object_name "[learning_content::get_category_name -category_id $parent_id]:$object_name"
                set parent_id [category::get_parent -category_id $object_id]
            }
        }
        default {
            set object_name [db_string get_object_name {} -default ""]
        }
    }
    return $object_name
}

ad_proc -public planner::get_object_type_pretty_name {
    {-object_type:required}
} {
    Gets the pretty name for an object type, some object_types have 
    a special pretty name defined here and the rest use the standard

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Oct-2008

} {
    switch $object_type {
        "forums_forum" {
            set object_type_name [_ forums.Forum]
        }
	"forums_message" {
	    set object_type_name [_ forums.forums_message]
	}
        "evaluation_tasks" {
            set object_type_name [_ dotlrn-evaluation.Evaluation_]
        }
        "file_storage_object" {
            set object_type_name [_ file-storage.file]
        }
        "content_extlink" {
            set object_type_name [_ file-storage.link]
        }
        "content_folder" {
            set object_type_name [_ file-storage.Folder]
        }
        "as_assessments" {
            set object_type_name [_ assessment.Assessment]
        }
        "::xowiki::PlainPage" {
            set object_type_name [_ planner.blocks_text_page]
        }
        "::xowiki::Page" {
            set object_type_name [_ planner.blocks_web_page]
        }
        "chat_room" {
            set object_type_name [_ chat.chat_rooms]
        }
        default {
            set object_type_name [subsite::util::object_type_pretty_name $object_type]
        }
    }
    return $object_type_name
}

ad_proc -public planner::get_object_icon {
    {-object_type:required}
} {
    Gets the icon of an object depending on the object_type

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    switch $object_type {
        "evaluation_tasks" {
            set object_image "/resources/theme-tupi/images/added/evaluation_evaluations_portlet.png"
        }
        "as_assessments" {
            set object_image "/resources/theme-tupi/images/added/assessment_portlet.png"
        }
        "forums_forum" {
            set object_image "/resources/theme-tupi/images/added/forums_portlet.png"
        }
        "::xowiki::PlainPage" {
            set object_image "/resources/dotlrn/text_pages.png"
        }
        "::xowiki::Page" {
            set object_image "/resources/dotlrn/web_pages.png"
        }
        "file_storage_object" {
            set object_image "/resources/file-storage/file.gif"
        }
        "content_extlink" {
            set object_image "/resources/acs-subsite/url-button.gif"
        }
        "content_folder" {
            set object_image "/resources/file-storage/folder.gif"
        }
        "category" -
        "apm_package" {
            set object_image "/resources/theme-tupi/images/added/learning_content.png"
        }
        "chat_room" {
            set object_image "/resources/theme-tupi/images/added/chat_portlet.png"
        }
        default {
            set object_image ""
        }
    }
    return $object_image
}

ad_proc -public planner::show_alert_message {
    {-object_id:required}
    {-community_url "/dotlrn"}
} {
    Set a cookie with the message to be shown in the master 
    after an activity has been added to blocks from another's 
    package view.
    This is to let the user know that the activity has been 
    added and that can continue editing the activity

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set community_url "${community_url}planner/"
    set object_type [acs_object_type $object_id]
    if {[string equal $object_type "content_item"]} {
        set object_type [content::item::get_content_type -item_id $object_id]
    }
    set object_name [planner::get_object_name -object_id $object_id -object_type $object_type]
    set object_type [planner::get_object_type_pretty_name -object_type $object_type]
    set user_message "[_ planner.blocks_new_object_alert_message]"
    util_user_message -html -message $user_message
}

ad_proc -public planner::enabled_p {
    {-community_id:required}
} {
    Check if the Block View is enabled for a community

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    if { [catch { set enabled_p [db_string check_enabled_p {} -default ""] } errmsg ] } {
        set enabled_p "f"
    }
    return $enabled_p
}

ad_proc -public planner::enable {
    {-community_id:required}
    {-enable_p "f"}
} {
    Mount the dependencies to enable the Block View for a community

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set community_url [dotlrn_community::get_community_url $community_id]
    #instantiate pages package
    set activity "pages"
    if {![site_node::exists_p -url "${community_url}${activity}" ]} {
        dotlrn::instantiate_and_mount -mount_point "pages" $community_id pages
    }
    #check if assessment is mounted, if not mount it
    set activity "assessment"
    if {![site_node::exists_p -url "${community_url}${activity}" ]} {
        dotlrn_community::add_applet_to_community $community_id dotlrn_assessment
    }
    #check if evaluation is mounted, if not mount it
    set activity "evaluation"
    if {![site_node::exists_p -url "${community_url}${activity}"]} {
        dotlrn_community::add_applet_to_community $community_id dotlrn_evaluation
    }
    if {[apm_package_installed_p "chat"]} {
        #check if chat is mounted, if not mount it
        set activity "chat"
        if {![site_node::exists_p -url "${community_url}${activity}"]} {
            dotlrn_community::add_applet_to_community $community_id dotlrn_chat
        }
    }
    if {[apm_package_installed_p "learning-content"]} {
        #check if content is mounted, if not mount it
        set activity "learning-content"
        if {![site_node::exists_p -url "${community_url}${activity}"]} {
            dotlrn_community::add_applet_to_community $community_id dotlrn_learning_content
        }
    }
    set package_id [dotlrn_community::get_package_id $community_id]
    if {![site_node_apm_integration::get_child_package_id \
              -package_id $package_id \
              -package_key "planner"]} {
	# Mount the planner package
	dotlrn::instantiate_and_mount $community_id planner
    }
    #Insert the community to blocks view and create the first empty block by default
    if { [string equal [planner::enabled_p -community_id $community_id] ""] } {
        set current_index 0
        set course_mode "weeks"
        set block_id [db_nextval blocks_seq]
        db_dml insert_block_mode { *SQL* }
        db_dml create_first_block { *SQL* }
    }
    db_dml block_view_enable { *SQL* }
}

ad_proc -public planner::get_admin_links_query {
    {-community_id:required}
} {
    Check if the Block View is enabled for a community

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set links_list "'members', 'calendar/cal-item-new', 'subcommunity-new', 'spam-recipients?referer=one-community-admin'"
    set links_query "select distinct ta.item_id, ta.name, ta.image, ta.url, ta.all_classes_p
    from tupi_admin_links ta, community_admin_links ca 
    where ((ta.item_id = ca.item_id 
        and ca.community_id = :community_id) or ta.all_classes_p = 't') and url in ( $links_list )"
    return $links_query
}

ad_proc -public planner::get_block_dates {
    {-start_clock:required}
} {
    Returns the dates of a block when using weeks mode
    The format is "day month - day month"

    @author Alvaro Rodriguez ( alvaro@viaro.net )
    @creation-date Jul-2008

} {
    set start_date [clock format $start_clock -format "%Y-%m-%d"]
    set start_date [lc_time_fmt $start_date "%d %B"]
    set start_clock [clock scan "6 day" -base $start_clock]
    set end_date [clock format $start_clock -format "%Y-%m-%d"]
    set end_date [lc_time_fmt $end_date "%d %B"]
    set dates "$start_date - $end_date"
    return $dates
}

ad_proc -callback planner::extend_form {
    -block_id:required
    {-block_object_type ""}
    {-form_name}
    {-referrer ""}
    {-community_id ""}
} {
    This callback is invoked when serving the form to create a 
    new object from the packages involved in the blocks view
    for dotlrn when using blocks view mode.

    @author Alvaro Rodriguez ( alvaro@viaro.net ) 
    @creation-date Jul-2008
} -

ad_proc -callback planner::insert_object {
    -block_id:required
    -object_id:required
    {-community_id ""}
    {-resource_type "object"}
    {-label_text ""}
} {
    This callback is invoked when submiting the form to create a 
    new object from the packages involved in the blocks view
    for dotlrn when using blocks view mode.

    @author Alvaro Rodriguez ( alvaro@viaro.net ) 
    @creation-date Jul-2008
} -

ad_proc -callback planner::new_url {
    -object_id:required
} {
   This callback is invoked when a URL needs to be generated for the
   edit action of an object.
} -

ad_proc -callback planner::edit_url {
    -object_id:required
} {
   This callback is invoked when a URL needs to be generated for the 
   edit action of an object.
} -

ad_proc -callback planner::delete_url {
    -object_id:required
} {
   This callback is invoked when a URL needs to be generated for the 
   delete action of an object.
} -

ad_proc -callback planner::flush_blocks_cache {
    -community_id:required
    {-navigation_p 1}
} {
    This callback is invoked when add/edit/delete an object 
    from the blocks to flush the cache

    @author Alvaro Rodriguez ( alvaro@viaro.net ) 
    @creation-date Jan-2009
} -

ad_proc -public -callback planner::extend_form -impl planner {} {

    @author alvaro@viaro.net
    @creation_date Jul-2008

    Extend the form of the insert/edit page to add the objects to the 
    blocks view table, this callbacks works for most packages in blocks mode 
    (evaluation, assessment, forums, chat)

} {
    if { $block_id != 0 } {
        ad_form -extend -name $form_name -form { {block_id:text(hidden) {value $block_id}}
	    {block_object_type:text(hidden) {value $block_object_type}}
	}
    }
}

ad_proc -public -callback planner::insert_object -impl planner {} {

    @author alvaro@viaro.net
    @creation_date Jul-2008

    Insert the recently created object into the blocks view objects table
    this callbacks works for most packages in blocks mode (evaluation,
    assessment, forums, chat)

} {
    if { $block_id != 0 } {
	if {[empty_string_p $resource_type]} {
	    set resource_type "object"
	}
        set object_index [planner::get_next_object_index -block_id $block_id]
        planner::insert_object_to_block -block_id $block_id -object_id $object_id -object_index $object_index -resource_type $resource_type -label_text $label_text
        set community_id [planner::get_community_id_from_block_id -block_id $block_id]
        set community_url [dotlrn_community::get_community_url $community_id]
        planner::show_alert_message -object_id $object_id -community_url $community_url
    } else {
        set community_id [dotlrn_community::get_community_id]
    }
    planner::flush_blocks_cache -community_id $community_id
}

ad_proc -public -callback planner::flush_blocks_cache -impl planner {} {

    @author alvaro@viaro.net
    @creation_date Jan-2009

    Flush the cache of the blocks content when doing an action in the blocks

} {
    planner::flush_blocks_cache -community_id $community_id -navigation_p $navigation_p
}
