<?xml version="1.0"?>

<queryset>

    <fullquery name="get_grades_info">
        <querytext>
            select eg.grade_plural_name as grade_name, eg.grade_id
            from evaluation_grades eg, acs_objects ao, cr_items cri
            where cri.live_revision = eg.grade_id
              and eg.grade_item_id = ao.object_id
              and ao.context_id = :ev_package_id
            order by grade_plural_name desc
        </querytext>
    </fullquery>

    <fullquery name="get_categories">
        <querytext>
            select c.category_id as category_id from categories c, category_translations ct
            where parent_id is null
                and tree_id = :tree_id
                and c.category_id = ct.category_id
                and locale = :locale
            order by name
        </querytext>
    </fullquery>

    <fullquery name="get_objects_name">
        <querytext>
        select o.*, ao.title as name
        from (select distinct object_id
                from blocks_objects
                where $blocks_clause) o,
            acs_objects ao
        where o.object_id = ao.object_id
        and ao.object_type = :object_type
        </querytext>
    </fullquery>

    <fullquery name="get_items_name">
        <querytext>
        select o.*, cr.title as name
        from (select distinct object_id
                from blocks_objects
                where $blocks_clause) o,
            cr_revisions cr
        where item_id = o.object_id
        and (select content_type 
            from cr_items 
            where item_id = o.object_id) = :object_type
        and revision_id = (select coalesce(live_revision, latest_revision) 
                            from cr_items where item_id = o.object_id)
        </querytext>
    </fullquery>

    <fullquery name="get_tasks_name">
        <querytext>
        select o.*, ev.task_name as name
        from (select distinct object_id
                from blocks_objects
                where $blocks_clause) o,
            evaluation_tasksi ev
        where task_item_id = o.object_id
        and (select content_type 
            from cr_items 
            where item_id = o.object_id) = :object_type
        and revision_id = (select coalesce(live_revision, latest_revision)
                            from cr_items where item_id = o.object_id)
        </querytext>
    </fullquery>

    <fullquery name="get_chat_rooms_name">
        <querytext>
        select o.*, cr.pretty_name as name
        from (select distinct object_id
                from blocks_objects
                where $blocks_clause) o,
            chat_rooms cr
        where o.object_id = cr.room_id
        and (select object_type 
            from acs_objects 
            where object_id = o.object_id) = :object_type
        </querytext>
    </fullquery>

    <fullquery name="get_links_name">
        <querytext>
        select o.*, cre.label as name
        from (select distinct object_id
                from blocks_objects
                where $blocks_clause) o,
            cr_extlinks cre
        where o.object_id = cre.extlink_id
        </querytext>
    </fullquery>

    <fullquery name="get_community_blocks">
        <querytext>
        select block_id
        from blocks_blocks
        where community_id = :community_id
        and block_index <= ( 
            select number_of_blocks 
            from blocks_course_mode 
            where community_id = :community_id )
        </querytext>
    </fullquery>

</queryset>
