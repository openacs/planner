ad_page_contract {
    Set cookie for blocks edit mode

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {cookie_value 0}
    {return_url ""}
}

ad_set_cookie blocks_edit_mode $cookie_value
ad_returnredirect "$return_url"