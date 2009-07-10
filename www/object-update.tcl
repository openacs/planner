ad_page_contract {
    Update the object when moved to another block

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_object_id 0}
    {block_id 0}
}

set object_info_p [db_0or1row get_object_info { *SQL* }]
if {$object_info_p} {
    set block_display [db_string get_block_display {} -default "t"]

    if { ![empty_string_p $indent] } {
        set indent [expr {$indent * 20}]
    } else {
        set indent 0
    }
    if {$object_id != 0} {
        set object_type [acs_object_type $object_id]
        if { [string equal $object_type "content_item"] } {
            set object_type [content::item::content_type -item_id $object_id]
        }
        set image_specs "width=16 height=16"
        set object_image [planner::get_object_icon -object_type $object_type]
        set object_name [planner::get_object_name -object_id $object_id -object_type $object_type]
    } else {
        set object_name [lindex $label 0]
    }
}