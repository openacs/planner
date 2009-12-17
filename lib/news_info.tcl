# 
#
# show news of a community_id
#
# @author Marco Rodriguez (mterodsan@galileo.edu)
# @creation-date 2009-08-04
# @arch-tag: cda5af75-9c4b-49af-9d70-f624a91f3fcb
# @cvs-id $Id$

foreach required_param {community_id} {
    if {![info exists $required_param]} {
        return -code error "$required_param is a required parameter."
    }
}
foreach optional_param {max} {
    if {![info exists $optional_param]} {
        set $optional_param {}
    }
}

set community_url [dotlrn_community::get_community_url $community_id]
set news_p [site_node::exists_p -url "${community_url}news" ]
if { $news_p } {
    set news_package_id [site_node::get_object_id -node_id [site_node::get_node_id -url "${community_url}news"]]
    db_multirow news news {*SQL*} { 
        set publish_body [string_truncate -len 60 $publish_body]
    }
}

if {![exists_and_not_null max]} {
    set max [multirow size news]
}