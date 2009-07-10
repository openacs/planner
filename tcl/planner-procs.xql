<?xml version="1.0"?>

<queryset>

    <fullquery name="planner::get_objects_names.get_object_types">
        <querytext>
        select distinct (case object_type when 'content_item' 
                        then (select content_type 
                                from cr_items 
                                where item_id = ba.object_id)
                        else ba.object_type end) as object_type
        from ( select distinct bo.object_id, 
                (select object_type 
                    from acs_objects 
                    where object_id = bo.object_id) as object_type
                from blocks_objects bo, (select block_id from blocks_blocks where community_id = :community_id) bb
                where bb.block_id = bo.block_id ) ba
        </querytext>
    </fullquery>

    <fullquery name="planner::get_objects_names.get_objects_name">
        <querytext>
        select o.*, ao.title as name
        from (select distinct object_id
                from blocks_objects bo, (select block_id from blocks_blocks where community_id = :community_id) bb
                where bb.block_id = bo.block_id) o,
            acs_objects ao
        where o.object_id = ao.object_id
        and ao.object_type = :object_type
        </querytext>
    </fullquery>

    <fullquery name="planner::get_objects_names.get_items_name">
        <querytext>
        select o.*, cr.title as name
        from (select distinct object_id
                from blocks_objects bo, (select block_id from blocks_blocks where community_id = :community_id) bb
                where bb.block_id = bo.block_id) o,
            cr_revisions cr
        where item_id = o.object_id
        and (select content_type 
            from cr_items 
            where item_id = o.object_id) = :object_type
        and revision_id = (select coalesce(live_revision, latest_revision) 
                            from cr_items where item_id = o.object_id)
        </querytext>
    </fullquery>

    <fullquery name="planner::get_objects_names.get_tasks_name">
        <querytext>
        select o.*, ev.task_name as name
        from (select distinct object_id
                from blocks_objects bo, (select block_id from blocks_blocks where community_id = :community_id) bb
                where bb.block_id = bo.block_id) o,
            evaluation_tasksi ev
        where task_item_id = o.object_id
        and (select content_type 
            from cr_items 
            where item_id = o.object_id) = :object_type
        and revision_id = (select coalesce(live_revision, latest_revision)
                            from cr_items where item_id = o.object_id)
        </querytext>
    </fullquery>

    <fullquery name="planner::get_objects_names.get_chat_rooms_name">
        <querytext>
        select o.*, cr.pretty_name as name
        from (select distinct object_id
                from blocks_objects bo, (select block_id from blocks_blocks where community_id = :community_id) bb
                where bb.block_id = bo.block_id) o,
            chat_rooms cr
        where o.object_id = cr.room_id
        and (select object_type 
            from acs_objects 
            where object_id = o.object_id) = :object_type
        </querytext>
    </fullquery>

    <fullquery name="planner::get_objects_names.get_links_name">
        <querytext>
        select o.*, cre.label as name
        from (select distinct object_id
                from blocks_objects bo, (select block_id from blocks_blocks where community_id = :community_id) bb
                where bb.block_id = bo.block_id) o,
            cr_extlinks cre
        where o.object_id = cre.extlink_id
        </querytext>
    </fullquery>

    <fullquery name="planner::get_object_types_names.get_object_types">
        <querytext>
        select distinct (case object_type when 'content_item'
                        then (select content_type
                                from cr_items
                                where item_id = ba.object_id)
                        else ba.object_type end) as object_type
        from ( select distinct bo.object_id,
                (select object_type
                    from acs_objects
                    where object_id = bo.object_id) as object_type
                from blocks_objects bo, (select block_id from blocks_blocks where community_id = :community_id) bb
                where bb.block_id = bo.block_id ) ba
        </querytext>
    </fullquery>

    <fullquery name="planner::get_content_categories.get_categories">
        <querytext>
            select c.category_id as category_id from categories c, category_translations ct
            where parent_id is null
                and tree_id = :tree_id
                and c.category_id = ct.category_id
                and locale = :locale
            order by name
        </querytext>
    </fullquery>

    <fullquery name="planner::get_blocks_navigation_info_not_cached.get_blocks_info">
        <querytext>
        select ba.*, 
            (case object_type when 'content_item' 
                then (select content_type from cr_items where item_id = object_id) 
                else object_type end) as object_type
        from (
            select bo.object_id, bo.display_p as object_display, bb.block_id, bb.block_index,
            (select count(*) from blocks_objects where block_id = bb.block_id) as count,
            bb.block_name, bb.display_p as block_display,
            (select object_type from acs_objects where object_id = bo.object_id) as object_type
            from blocks_blocks bb, blocks_objects bo
            where bb.community_id = :community_id
            and bb.block_index <= ( select number_of_blocks from blocks_course_mode where community_id = :community_id )
            and bb.block_id = bo.block_id
            and bo.object_id != 0
            order by bb.block_index, bo.object_index) ba
        </querytext>
    </fullquery>

    <fullquery name="planner::get_blocks_admin_info_not_cached.get_blocks_admin_info">
        <querytext>
    select ba.*,
        (case object_type when 'content_item' 
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

    <fullquery name="planner::get_blocks_info_not_cached.get_blocks_info">
        <querytext>
    select ba.*,
        (case object_type when 'content_item' 
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

   <fullquery name="planner::get_next_object_index.get_max_index">
        <querytext>
            select max(object_index) 
            from blocks_objects 
            where block_id = :block_id
         </querytext>
   </fullquery>

   <fullquery name="planner::insert_object_to_block.insert_object_to_block">
        <querytext>
            insert into 
            blocks_objects ( block_object_id, block_id, resource_type, object_id, label, object_index, indent, display_p ) 
            values ( :block_object_id, :block_id, :resource_type, :object_id, :label_text, :object_index, :indent, 't' )
         </querytext>
   </fullquery>

   <fullquery name="planner::get_block_index.get_block_index">
        <querytext>
            select block_index 
            from blocks_blocks
            where block_id = :block_id
         </querytext>
   </fullquery>

   <fullquery name="planner::get_object_index.get_object_index">
        <querytext>
            select object_index 
            from blocks_objects
            where block_object_id = :block_object_id
         </querytext>
   </fullquery>

   <fullquery name="planner::get_object_id.get_object_id">
        <querytext>
            select object_id 
            from blocks_objects
            where block_object_id = :block_object_id
         </querytext>
   </fullquery>

   <fullquery name="planner::get_label.get_label">
        <querytext>
            select label
            from blocks_objects
            where block_object_id = :block_object_id
         </querytext>
   </fullquery>

   <fullquery name="planner::update_block_index.update_block_index">
        <querytext>
            update blocks_blocks 
            set block_index = :block_index 
            where block_id = :block_id
         </querytext>
   </fullquery>

   <fullquery name="planner::enabled_p.check_enabled_p">
        <querytext>
            select enabled_p 
            from blocks_course_mode
            where community_id = :community_id
         </querytext>
   </fullquery>

   <fullquery name="planner::count_block_objects.count_block_objects">
        <querytext>
            select count(*) 
            from blocks_objects
            where block_id = :block_id
         </querytext>
   </fullquery>

   <fullquery name="planner::get_block_id.get_block_id">
        <querytext>
            select block_id
            from blocks_objects
            where block_object_id = :block_object_id
         </querytext>
   </fullquery>

    <fullquery name="planner::enable.insert_block_mode">
        <querytext>
            insert into 
            blocks_course_mode ( community_id, course_mode, number_of_blocks, enabled_p ) 
            values ( :community_id, 'weeks', 0, :enable_p)
        </querytext>
    </fullquery>

    <fullquery name="planner::enable.create_first_block">
        <querytext>
            insert into 
            blocks_blocks ( community_id, block_id, block_index, display_p ) 
            values ( :community_id, :block_id, :current_index, 't' )
        </querytext>
    </fullquery>

    <fullquery name="planner::enable.block_view_enable">
        <querytext>
            update blocks_course_mode
            set enabled_p = :enable_p
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="planner::get_object_name.get_task_name">
        <querytext>
            select task_name 
            from evaluation_tasksi 
            where task_item_id = :object_id
	    and revision_id = :revision_id
        </querytext>
    </fullquery>

    <fullquery name="planner::get_object_name.get_item_name">
        <querytext>
            select title 
            from cr_revisions 
            where revision_id = (
                select coalesce(live_revision,latest_revision) 
                from cr_items 
                where item_id = :object_id)
        </querytext>
    </fullquery>

    <fullquery name="planner::get_object_name.get_object_name">
        <querytext>
            select title 
            from acs_objects 
            where object_id = :object_id 
        </querytext>
    </fullquery>

    <fullquery name="planner::get_object_name.get_chat_room_name">
        <querytext>
            select pretty_name
            from chat_rooms
            where room_id = :object_id 
        </querytext>
    </fullquery>

    <fullquery name="planner::get_mode.get_mode">
        <querytext>
            select course_mode
            from blocks_course_mode
            where community_id = :community_id 
        </querytext>
    </fullquery>

    <fullquery name="planner::get_community_id_from_block_id.get_community_id">
        <querytext>
	    select community_id
            from blocks_blocks
            where block_id = :block_id
        </querytext>
    </fullquery>

</queryset>
