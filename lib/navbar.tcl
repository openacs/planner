# 
#
# navigation bar
#
# @author Marco Rodriguez (mterodsan@galileo.edu)
# @creation-date 2009-08-04
# @arch-tag: e4b336b2-45c4-46f0-9225-7a349a449d35
# @cvs-id $Id$

foreach required_param {} {
    if {![info exists $required_param]} {
        return -code error "$required_param is a required parameter."
    }
}
foreach optional_param {date return_url} {
    if {![info exists $optional_param]} {
        set $optional_param {}
    }
}
if {![exists_and_not_null return_url]} {
    set return_url ".."
}
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set admin_p [dotlrn::user_can_admin_community_p -user_id $user_id -community_id $community_id]
set community_url [dotlrn_community::get_community_url $community_id]
set pages_p [site_node::exists_p -url "${community_url}pages" ]
set assessment_p [site_node::exists_p -url "${community_url}assessment" ]
set evaluation_p [site_node::exists_p -url "${community_url}evaluation" ]
set chat_p [site_node::exists_p -url "${community_url}chat" ]
set learning_content_p [site_node::exists_p -url "${community_url}learning-content" ]
set forums_p [site_node::exists_p -url "${community_url}forums" ]
set faq_p [site_node::exists_p -url "${community_url}faq" ]
set static_portlet_p [site_node::exists_p -url "${community_url}static-portlet" ]
set news_p [site_node::exists_p -url "${community_url}news" ]
set lorsm_p [site_node::exists_p -url "${community_url}lorsm" ]
set sub_pretty_name [_ dotlrn.subcommunities_pretty_name]

set portal_id [dotlrn_community::get_portal_id -community_id $community_id ]

set effectAppear [ah::effects -element "content_'+id+'" -effect "BlindDown" -options "duration: 1"]
set effectPuff [ah::effects -element "content_'+id+'" -effect "BlindUp" -options "duration: 1"]

set script "
function showMenu(id){
document.getElementById('img_'+id).src='/resources/planner/minus.gif';
document.getElementById('link_'+id).href='javascript:hideMenu('+id+')';
${effectAppear}
}
function hideMenu(id){
document.getElementById('img_'+id).src='/resources/planner/plus.gif';
document.getElementById('link_'+id).href='javascript:showMenu('+id+')';
${effectPuff}
}
"
template::head::add_script -type "text/javascript" -script $script
