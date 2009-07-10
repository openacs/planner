ad_page_contract {
  Edit course view mode

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {return_url ""}
    {course_format ""}
    {__refreshing_p 0}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set title "[_ planner.blocks_course_edit_mode]"
set context [list $title]

set number_select [list]
for { set i 0 } { $i <= 52 } { incr i } {
    lappend number_select [list $i $i]
}
set start_date [clock format [clock seconds] -format "%Y %m %d"]
db_0or1row blocks_course_mode_select { *SQL* }
if {[empty_string_p $course_format]} {
    set course_format $course_mode
}

ad_form -name blocks_course_mode \
    -form {
        {course_format:text(select),optional 
            {label "[_ planner.blocks_format]"} 
            {options {{ "[_ planner.blocks_weekly_format]" weeks } 
            { "[_ planner.blocks_topics_format]" topics }}}
            {html {onChange "document.blocks_course_mode.__refreshing_p.value='1';submit()"}}
            {value $course_format}
        }
        {number_of_blocks:text(select),optional 
            {label "[_ planner.blocks_number_of_weeks]"} 
            {options {$number_select}}
            {value $number_of_blocks}
        }
    }

if {[string eq $course_format "weeks"]} {
    ad_form -extend -name blocks_course_mode \
        -form {
            {start_date:date(date),to_sql(linear_date)
                {label "[_ planner.blocks_start_date]"}
                {format "YYYY MM DD"}
                {value $start_date}
                {after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('start_date', 'd-m-y');" /> } }
            }
        }
} else {
    ad_form -extend -name blocks_course_mode \
        -form {
            {start_date:date(date),to_sql(linear_date),optional
                {label "[_ planner.blocks_start_date]"}
                {format "YYYY MM DD"}
                {value $start_date}
                {after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('start_date', 'd-m-y');" />} }
            }
        }
}

ad_form -extend -name blocks_course_mode \
    -validate {
        {start_date
            {[lindex $start_date 0] <= 2035}
            { [_ planner.blocks_year_error] }
        }
    } -on_submit {
        set current_blocks [db_string get_number_of_blocks {} -default 0]
        set course_mode $course_format
        db_dml update_block_mode { *SQL* }
        if { ![empty_string_p $current_blocks] && $number_of_blocks > $current_blocks } {
            # If number of blocks is greater than current blocks, create the rest
            for { set i [expr $current_blocks + 1] } { $i <= $number_of_blocks } { incr i } {
                set current_index $i
                set block_id [db_nextval blocks_seq]
                db_dml create_block { *SQL* }
            }
        }
    } -after_submit {
        ad_returnredirect $return_url
    }
