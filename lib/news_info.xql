<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Marco Rodriguez (mterodsan@galileo.edu) -->
<!-- @creation-date 2009-08-04 -->
<!-- @arch-tag: a421ef4b-26ab-45aa-ad87-58d00eae08f0 -->
<!-- @cvs-id $Id$ -->

<queryset>
    <fullquery name="news">
        <querytext>
            select * 
            from news_item_full_active 
            where package_id=:news_package_id 
            order by item_id desc
        </querytext>
    </fullquery>
</queryset>