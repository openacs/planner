<?xml version="1.0"?>

<queryset>

    <fullquery name="update_block_object">
        <querytext>
            update blocks_objects 
            set label = :label_object 
            where block_object_id = :block_object_id 
        </querytext>
    </fullquery>

</queryset>
