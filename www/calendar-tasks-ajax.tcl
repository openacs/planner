# 

ad_page_contract {
    
    show calendar task information
    
    @author Marco Rodriguez (mterodsan@galileo.edu)
    @creation-date 2009-08-05
    @arch-tag: 3c92e666-f02d-4dc6-ac74-1299628000c8
    @cvs-id $Id$
} {
    date
} -properties {
} -validate {
} -errors {
}

set current_date $date
set calendars_clause [db_map dbqd.calendar.www.views.openacs_calendar] 

set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
set node_id [site_node::get_node_id -url  "${community_url}calendar" ]
set package_id [site_node::get_object_id -node_id $node_id]

set user_id [ad_conn user_id]

multirow create items \
    event_name \
    description \
    calendar_name

set additional_limitations_clause ""
set additional_select_clause ""
set order_by_clause " order by name"
set interval_limitation_clause [db_map dbqd.calendar.www.views.day_interval_limitation] 

db_foreach dbqd.calendar.www.views.select_all_day_items {} {
    set name [string map {"Due date: " ""} $name]
    set name [string_truncate -len 20 $name]
    multirow append items \
        $name \
        $description \
        $calendar_name \
}
