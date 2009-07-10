<?xml version="1.0"?>

<queryset>

    <fullquery name="get_object_indent">
        <querytext>
            select indent 
            from blocks_objects 
            where block_object_id = :block_object_id
        </querytext>
    </fullquery>

    <fullquery name="update_object_indent">
        <querytext>
            update blocks_objects 
            set indent = :spaces 
            where block_object_id = :block_object_id
        </querytext>
    </fullquery>

</queryset>
