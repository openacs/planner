#
#
# mini-calendar
#
# @author Marco Rodriguez (mterodsan@galileo.edu)
# @creation-date 2009-08-04
# @arch-tag: e4b336b2-45c4-46f0-9225-7a349a449d35
# @cvs-id $Id$  

if {![exists_and_not_null base_url]} {
    set base_url [ad_conn url]
}

if {![exists_and_not_null date]} {
    set date [dt_sysdate]
} 

ad_form -name go-to-date -method get -has_submit 1 -action "$base_url"  -export [lappend list_of_vars page_num] -html {class inline-form} -form {
    {date:text,nospell,optional
        {label "[_ acs-datetime.Date]"}
        {html {size 10}}
    }
    {btn_ok:text(submit)
        {label "[_ calendar.Go_to_date]"}
    } 
    {view:text(hidden)
        {label ""}
        {value "day"}
    }
} -on_submit { }


if {[exists_and_not_null page_num]} {
    set page_num_formvar [export_form_vars page_num]
    set page_num "&page_num=$page_num"
} else {
    set page_num_formvar ""
    set page_num ""
}

# Determine whether we need to pass on the period_days variable from the list view
if {[string equal $view list]} {
    if {![exists_and_not_null period_days] || [string equal $period_days [parameter::get -parameter ListView_DefaultPeriodDays -default 31]]} {
	set url_stub_period_days ""
    } else {
	set url_stub_period_days "&period_days=${period_days}"
    }
} else {
    set url_stub_period_days ""
}

array set message_key_array {
    list #acs-datetime.List#
    day #acs-datetime.Day#
    week #acs-datetime.Week#
    month #acs-datetime.Month#
}

# Create row with existing views
multirow create views name text active_p url
foreach viewname {list day week month} {
    if { [string equal $viewname $view] } {
        set active_p t
    } else {
        set active_p f
    }
    if {[string equal $viewname list]} {
	multirow append views [lang::util::localize $message_key_array($viewname)] $viewname $active_p \
	    "[export_vars -base $base_url {date {view $viewname}}]${page_num}${url_stub_period_days}"
    } else {
	multirow append views [lang::util::localize $message_key_array($viewname)] $viewname $active_p \
	    "[export_vars -base $base_url {date {view $viewname}}]${page_num}"
    }
}

set list_of_vars [list]

# Get the current month, day, and the first day of the month
if {[catch {
    dt_get_info $date
} errmsg]} {
    set date [dt_sysdate]
    dt_get_info $date
}

set now        [clock scan $date]
    set date_list [dt_ansi_to_list $date]
    set year [dt_trim_leading_zeros [lindex $date_list 0]]
    set month [dt_trim_leading_zeros [lindex $date_list 1]]
    set day [dt_trim_leading_zeros [lindex $date_list 2]]

set months_list [dt_month_names]
set curr_month_idx  [expr [dt_trim_leading_zeros [clock format $now -format "%m"]]-1]
set curr_day [clock format $now -format "%d"]
set curr_month [clock format $now -format "%B"]
set curr_year [clock format $now -format "%Y"]
if [string equal $view month] {
    set prev_year [clock format [clock scan "1 year ago" -base $now] -format "%Y-%m-%d"]
    set next_year [clock format [clock scan "1 year" -base $now] -format "%Y-%m-%d"]
    set prev_year_url "$base_url?view=$view&date=[ad_urlencode $prev_year]${page_num}${url_stub_period_days}"
    set next_year_url "$base_url?view=$view&date=[ad_urlencode $next_year]${page_num}${url_stub_period_days}"

    set now         [clock scan $date]

    multirow create months name current_month_p new_row_p url

    for {set i 0} {$i < 12} {incr i} {

        set month [lindex $months_list $i]

        # show 3 months in a row

        set new_row_p [expr $i / 3]
#         if {($i != 0) && ([expr $i % 3] == 0)} {
#             set new_row_p t
#         } else {
#             set new_row_p f
#         }

        if {$i == $curr_month_idx} {
            set current_month_p t 
        } else {
            set current_month_p f
        }
        set target_date [clock format \
                             [clock scan "[expr $i-$curr_month_idx] month" -base $now] -format "%Y-%m-%d"]
        multirow append months $month $current_month_p $new_row_p  \
            "[export_vars -base $base_url {{date $target_date} view}]${page_num}${url_stub_period_days}"
        
    }
} else {
    set prev_month [clock format [clock scan "1 month ago" -base $now] -format "%Y-%m-%d"]
    set next_month [clock format [clock scan "1 month" -base $now] -format "%Y-%m-%d"]
    set prev_month_url "$base_url?view=$view&date=[ad_urlencode $prev_month]${page_num}${url_stub_period_days}"
    set next_month_url "$base_url?view=$view&date=[ad_urlencode $next_month]${page_num}${url_stub_period_days}"
    
    set first_day_of_week [lc_get firstdayofweek]
    set week_days [lc_get abday]
    set long_weekdays [lc_get day]
    multirow create days_of_week day_short day_num
    for {set i 0} {$i < 7} {incr i} {
        multirow append days_of_week \
            [lindex $week_days [expr [expr $i + $first_day_of_week] % 7]] \
            $i
    }

    multirow create days day_number beginning_of_week_p end_of_week_p today_p active_p url weekday day_num pretty_date date class

    set day_of_week 1

    set task_list [list]
    set additional_limitations_clause ""
    set additional_select_clause ""
    set order_by_clause " order by name"
    set current_date $date
    set community_id [dotlrn_community::get_community_id]
    set community_url [dotlrn_community::get_community_url $community_id]
    set user_id [ad_conn user_id]
    set node_id [site_node::get_node_id -url  "${community_url}calendar" ]
    set package_id [site_node::get_object_id -node_id $node_id]
    set calendars_clause [db_map dbqd.calendar.www.views.openacs_calendar]
    set interval_limitation_clause [db_map dbqd.calendar.www.views.month_interval_limitation] 
    # Get the beginning and end of the month in the system timezone
    set first_date_of_month [dt_julian_to_ansi $first_julian_date_of_month]
    set last_date_in_month [dt_julian_to_ansi $last_julian_date_in_month]
    
    set first_date_of_month_system "$first_date_of_month 00:00:00"
    set last_date_in_month_system "$last_date_in_month 23:59:59"
    db_foreach dbqd.calendar.www.views.select_all_day_items {} {
        set date_task [lindex [split $ansi_start_date " "] 0]
        lappend task_list $date_task
    }

    # Calculate number of active days
    set active_days_before_month [expr [expr [dt_first_day_of_month $year $month]] -1 ]
    set active_days_before_month [expr [expr $active_days_before_month + 7 - $first_day_of_week] % 7]

    set calendar_starts_with_julian_date [expr $first_julian_date_of_month - $active_days_before_month]
    set day_number [expr $days_in_last_month - $active_days_before_month + 1]

    for {set julian_date $calendar_starts_with_julian_date} {$julian_date <= [expr $last_julian_date + 7]} {incr julian_date} {
        if {$julian_date > $last_julian_date_in_month && [string equal $end_of_week_p t] } {
            break
        }
        set today_p f
        set active_p t

        if {$julian_date < $first_julian_date_of_month} {
            set active_p f
        } elseif {$julian_date > $last_julian_date_in_month} {
            set active_p f
        } 
        set ansi_date [dt_julian_to_ansi $julian_date]
        set pretty_date [lc_time_fmt $ansi_date %Q]
        
        if {$julian_date == $first_julian_date_of_month} {
            set day_number 1
        } elseif {$julian_date == [expr $last_julian_date_in_month +1]} {
            set day_number 1
        }

        if {$julian_date == $julian_date_today} {
            set today_p t
        }

        set day_num [expr { $day_of_week - 1 }]
        if { $day_of_week == 1} {
            set beginning_of_week_p t
        } else {
            set beginning_of_week_p f
        }

        if { $day_of_week == 7 } {
            set day_of_week 0
            set end_of_week_p t
        } else {
            set end_of_week_p f
        }

        set weekday [lindex $long_weekdays $day_of_week]

        if {[lsearch $task_list $ansi_date] eq -1 } {
            set class ""
        } else {
            set class "with_news"
        }

        multirow append days $day_number $beginning_of_week_p $end_of_week_p $today_p $active_p \
            "[export_vars -base $base_url {{date $ansi_date} view}]${page_num}${url_stub_period_days}" \
            $weekday \
            $day_num \
            $pretty_date $ansi_date $class

        incr day_number
        incr day_of_week
    }
}

set today_url "$base_url?view=day&date=[ad_urlencode [dt_sysdate]]${page_num}${url_stub_period_days}"

if { $view == "day" && [dt_sysdate] == $date } {
    set today_p t
} else {
    set today_p f
}


set form_vars ""
foreach var $list_of_vars {
    append form_vars "<INPUT TYPE=hidden name=[lindex $var 0] value=[lindex $var 1]>"
}

ad_form -name choose_new_date -show_required_p f -has_edit 0 -has_submit 0 -form {
    {new_date:date
        {label ""}
        {format {MM DD YYYY}}}
}


template::head::add_link  -rel "stylesheet" -type "text/css" -href "/resources/ajaxhelper/yui/container/assets/skins/sam/container.css"
template::head::add_javascript -src "/resources/ajaxhelper/yui/yahoo-dom-event/yahoo-dom-event.js" -order 1
template::head::add_javascript -src "/resources/ajaxhelper/yui/container/container-min.js" -order 2
template::head::add_javascript -src "/resources/ajaxhelper/yui/connection/connection-min.js" -order 2
template::head::add_javascript -src "/resources/planner/calendar-tasks.js" -order 3