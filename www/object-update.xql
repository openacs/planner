<?xml version="1.0"?>

<queryset>

    <fullquery name="get_object_info">
        <querytext>
        select object_id, display_p as object_display, indent, label
        from blocks_objects 
        where block_object_id = :block_object_id
        </querytext>
    </fullquery>

    <fullquery name="get_block_display">
        <querytext>
        select display_p 
        from blocks_blocks 
        where block_id = :block_id
        </querytext>
    </fullquery>

</queryset>
