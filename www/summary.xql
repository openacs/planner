<?xml version="1.0"?>

<queryset>

    <fullquery name="get_block_summary">
        <querytext>
            select summary
            from blocks_blocks 
            where block_id = :block_id 
        </querytext>
    </fullquery>

    <fullquery name="update_block_summary">
        <querytext>
            update blocks_blocks 
            set summary = :summary 
            where block_id = :block_id 
        </querytext>
    </fullquery>

</queryset>
