<?xml version="1.0"?>

<queryset>

    <fullquery name="object_show_hide">
        <querytext>
            update blocks_objects 
            set display_p = :display_p 
            where block_object_id = :block_object_id
        </querytext>
    </fullquery>

</queryset>
