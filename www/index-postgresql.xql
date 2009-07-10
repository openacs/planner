<?xml version="1.0"?>

<queryset>

    <fullquery name="get_blocks_admin_info">
        <querytext>
    select ba.*,
        (case when object_type='content_item' 
        then (select content_type from cr_items where item_id = object_id) 
        else object_type end) as object_type
    from (
        select bb.*, bo.object_index, bo.object_id, bo.display_p as object_display, bo.indent, bo.label, bo.resource_type, bo.block_object_id,
        (select object_type from acs_objects where object_id = bo.object_id) as object_type
        from (
            select bb.block_id, bb.block_index, bb.summary,
            bb.block_name, bb.display_p as block_display,
            (select count(*) from blocks_objects where block_id = bb.block_id) as count
            from blocks_blocks bb
            where bb.community_id = :community_id
            and bb.block_index <= (
                select number_of_blocks from blocks_course_mode where community_id = :community_id )
            order by block_index
        ) bb
            left join blocks_objects bo 
            on bb.block_id = bo.block_id
            order by bb.block_index, bo.object_index) ba
        </querytext>
    </fullquery>

    <fullquery name="get_blocks_info">
        <querytext>
    select ba.*,
        (case when object_type='content_item' 
        then (select content_type from cr_items where item_id = object_id) 
        else object_type end) as object_type
    from (
        select bb.*, bo.object_index, bo.object_id, bo.display_p as object_display, bo.indent, bo.label, bo.resource_type, bo.block_object_id,
        (select object_type from acs_objects where object_id = bo.object_id) as object_type
        from (
            select bb.block_id, bb.block_index, bb.summary,
            (select count(*) from blocks_objects where block_id = bb.block_id) as count,
            bb.block_name, bb.display_p as block_display
            from blocks_blocks bb
            where bb.community_id = :community_id
            and bb.block_index <= (
                select number_of_blocks from blocks_course_mode where community_id = :community_id )
            order by block_index
        ) bb
            left join blocks_objects bo 
            on bb.block_id = bo.block_id
            order by bb.block_index, bo.object_index) ba
        </querytext>
    </fullquery>

    <fullquery name="get_start_date">
        <querytext>
            select to_char(start_date, 'YYYY-MM-DD') 
            from blocks_course_mode 
            where community_id = :community_id 
        </querytext>
    </fullquery>

    <fullquery name="get_object_types">
        <querytext>
        select distinct (case when object_type='content_item'
                        then (select content_type
                                from cr_items
                                where item_id = ba.object_id)
                        else ba.object_type end) as object_type
        from ( select distinct bo.object_id,
                (select object_type
                    from acs_objects
                    where object_id = bo.object_id) as object_type
                from blocks_objects bo
                $blocks_clause ) ba
        </querytext>
    </fullquery>

</queryset>
