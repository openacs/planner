# 

ad_page_contract {
    
    show calendar info
    
    @author Marco Rodriguez (mterodsan@galileo.edu)
    @creation-date 2009-08-03
    @arch-tag: 3028bd87-e24b-435e-abe3-768e06d5c06e
    @cvs-id $Id$
} {
    view
    date
    {page_num ""}
} -properties {
} -validate {
} -errors {
}

set title "Calendario"

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set ad_conn_url [ad_conn url]

set export [ns_queryget export]

if {$export == "print"} {
    set view "list"
}

set return_url [ad_urlencode [ad_return_url]]
set add_item_url [export_vars -base "cal-item-new" {{return_url [ad_return_url]} view date}]
set url_stub_callback "../"

set admin_p [permission::permission_p -object_id $package_id -privilege calendar_admin]

set show_calendar_name_p [parameter::get -parameter Show_Calendar_Name_p -default 1]

set date [calendar::adjust_date -date $date]

if {$view == "list"} {
    if {[empty_string_p $start_date]} {
        set start_date $date
    }

    set ansi_list [split $start_date "- "]
    set ansi_year [lindex $ansi_list 0]
    set ansi_month [string trimleft [lindex $ansi_list 1] "0"]
    set ansi_day [string trimleft [lindex $ansi_list 2] "0"]
    set end_date [dt_julian_to_ansi [expr [dt_ansi_to_julian $ansi_year $ansi_month $ansi_day ] + $period_days]]
}
set calendar_personal_p [calendar::personal_p -calendar_id [lindex [lindex [calendar::calendar_list -package_id $package_id  ] 0] 1] ]

set notification_chunk [notification::display::request_widget \
                            -type calendar_notif \
                            -object_id $package_id \
                            -pretty_name [ad_conn instance_name] \
                            -url [ad_conn url] \
                           ]

# Header stuff
template::head::add_css -href "/resources/calendar/calendar.css" -media all 
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"
template::head::add_css -href "/resources/planner/navbar.css" -media all 

set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
set node_id [site_node::get_node_id -url  "${community_url}calendar" ]
set calendar_package_id [site_node::get_object_id -node_id $node_id]