<?xml version="1.0"?>

<queryset>

    <fullquery name="move_object_down">
        <querytext>
            update blocks_objects 
            set object_index = object_index - 1 
            where block_id = :to_block_id 
              and object_index > :object_index 
              and object_index < :tmp_object_index
        </querytext>
    </fullquery>

    <fullquery name="move_object_up">
        <querytext>
            update blocks_objects 
            set object_index = object_index + 1 
            where block_id = :to_block_id 
              and object_index >= :tmp_object_index 
              and object_index < :object_index
        </querytext>
    </fullquery>

    <fullquery name="update_objects_in_target_block">
        <querytext>
            update blocks_objects 
            set object_index = object_index + 1 
            where block_id = :to_block_id 
              and object_index >= :tmp_object_index
        </querytext>
    </fullquery>

    <fullquery name="update_objects_in_source_block">
        <querytext>
            update blocks_objects 
            set object_index = object_index - 1 
            where block_id = :block_id 
              and object_index > :object_index
        </querytext>
    </fullquery>

    <fullquery name="update_object_info">
        <querytext>
            update blocks_objects 
            set object_index = :tmp_object_index, block_id = :to_block_id 
            where block_object_id = :block_object_id
        </querytext>
    </fullquery>

    <fullquery name="get_object_info">
        <querytext>
            select object_index, block_id 
            from blocks_objects 
            where block_object_id = :block_object_id
        </querytext>
    </fullquery>

</queryset>
