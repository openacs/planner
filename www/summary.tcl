ad_page_contract {
  Edit Blocks Summary

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_id 0}
    {return_url ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set title "[_ planner.blocks_edit_block_summary]"
set context [list "$title"]
set summary [db_string get_block_summary {} -default ""]

ad_form -name blocks_summary \
    -export { block_id } \
    -form {
        {summary:richtext(richtext),optional  {label "[_ planner.blocks_summary]"} {options {editor xinha}} {value "$summary"}
            {html {id "summary" rows 20 cols 80}}}
    } -validate {
        {summary
            {[string bytelength $summary] <= 4000}
            { [_ planner.blocks_summary_must_be] }
        }
    } -on_submit {
        db_dml update_block_summary { *SQL* }
        ad_returnredirect "$return_url#block_$block_id"
    }
