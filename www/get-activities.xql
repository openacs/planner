<queryset>

    <fullquery name="get_as_title">
        <querytext>
        select title 
        from cr_revisions 
        where revision_id = :as_revision_id
        </querytext>
    </fullquery>

    <fullquery name="get_as_item">
        <querytext>
        select item_id, latest_revision as as_revision_id
        from cr_items 
        where parent_id = :folder_id 
          and content_type = :activity
          and latest_revision is not null
        </querytext>
    </fullquery>

    <fullquery name="get_web_pages">
        <querytext>
        select ci.item_id, cr.title as name
        from cr_revisions cr,
            (select item_id, latest_revision
            from cr_items
            where parent_id = :folder_id 
            and content_type = '::xowiki::Page'
            and name not like ('%:index')) ci
        where ci.latest_revision = cr.revision_id
        </querytext>
    </fullquery>

    <fullquery name="get_text_pages">
        <querytext>
        select ci.item_id, cr.title as name
        from cr_revisions cr,
            (select item_id, latest_revision
            from cr_items
            where parent_id = :folder_id 
            and content_type = '::xowiki::PlainPage') ci
        where ci.latest_revision = cr.revision_id
        </querytext>
    </fullquery>

    <fullquery name="get_forums">
        <querytext>
        select forum_id, name 
        from forums_forums ff 
        where package_id = :package_id
        and enabled_p = 't'
        </querytext>
    </fullquery>

    <fullquery name="get_grades_with_info">
        <querytext>
        select et.task_name, et.task_id, et.task_item_id, eg.grade_plural_name, eg.grade_id, eg.grade_item_id
        from cr_revisions cr, 
                evaluation_tasksi et,
                cr_items cri,
                cr_mime_types crmt,
                (select eg.grade_plural_name,
                    eg.grade_id, eg.grade_item_id
                from evaluation_grades eg, acs_objects ao, cr_items cri
                where cri.live_revision = eg.grade_id
                and eg.grade_item_id = ao.object_id
                and ao.context_id = :package_id
                order by grade_plural_name desc) eg
        where cr.revision_id = et.revision_id
        and et.grade_item_id = eg.grade_item_id
        and cri.live_revision = et.task_id
        and et.mime_type = crmt.mime_type
        order by eg.grade_plural_name desc
        </querytext>
    </fullquery>

    <fullquery name="get_chat_rooms">
        <querytext>
        select object_id as room_id,
          (select pretty_name from chat_rooms where room_id = ao.object_id) name 
        from acs_objects ao 
        where context_id = :package_id
        </querytext>
    </fullquery>

</queryset>
