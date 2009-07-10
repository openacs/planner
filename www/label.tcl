ad_page_contract {
    Add/Edit a label object to a block in the community

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_id 0}
    {block_object_id 0}
    {return_url "#block_$block_id"}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

if { $block_object_id == 0 } {
    set title "[_ planner.blocks_add_label]"
    set context [list "$title"]
} else {
    set title "[_ planner.blocks_edit_label]"
    set context [list "$title"]
}

set label_object [planner::get_label -block_object_id $block_object_id]

ad_form -name blocks_label \
    -export { block_id block_object_id } \
    -form {
        {label_object:richtext(richtext),optional  {label "[_ planner.blocks_label]"} {options {editor xinha width 500px height 250px}} {value "$label_object"}
            {html {id "label_object" rows 10 cols 60}}}
    } -on_submit {
        if { $block_object_id != 0 } {
            db_dml update_block_object { *SQL* }
        } else {
	    set object_index [planner::get_next_object_index -block_id $block_id]
            planner::insert_object_to_block -block_id $block_id -object_id 0 -object_index $object_index -label_text $label_object -resource_type "label"
        }
        ad_returnredirect "$return_url"
    } -validate {
        {label_object
            { ![empty_string_p $label_object] }
            "[_ planner.blocks_label_empty]"
        }
    }