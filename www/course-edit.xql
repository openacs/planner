<?xml version="1.0"?>

<queryset>

    <fullquery name="create_block">
        <querytext>
            insert into 
            blocks_blocks ( community_id, block_id, block_index, display_p ) 
            values ( :community_id, :block_id, :current_index, 't' )
        </querytext>
    </fullquery>

    <fullquery name="get_number_of_blocks">
        <querytext>
            select max(block_index) 
            from blocks_blocks 
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="clear_info_message">
        <querytext>
            update blocks_blocks
            set summary = ''
            where community_id = :community_id
            and block_index = 0
        </querytext>
    </fullquery>

</queryset>
