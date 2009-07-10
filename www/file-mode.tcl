ad_page_contract {
    Set cookie for blocks file-storage choose mode

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_id 0}
    {community_id 0}
    {return_url ""}
}

ad_set_cookie fs_block_id $block_id
ad_set_cookie fs_community_id $community_id
set package_id [dotlrn_community::get_package_id_from_package_key \
    -package_key "file-storage" -community_id $community_id]
# Uncomment this when file-storage uses the interface web 2.0
#set fs_web2 [parameter::get -package_id $package_id -parameter "UseAjaxFs" -default "-1"]
#ad_set_cookie fs_web2 $fs_web2
ad_returnredirect $return_url