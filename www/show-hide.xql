<?xml version="1.0"?>

<queryset>

    <fullquery name="blocks_show_hide">
        <querytext>
            update blocks_blocks 
            set display_p = :display_p 
            where block_id = :block_id
        </querytext>
    </fullquery>

</queryset>
