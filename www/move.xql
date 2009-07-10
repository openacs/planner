<?xml version="1.0"?>

<queryset>

    <fullquery name="move_block_down">
        <querytext>
            update blocks_blocks 
            set block_index = block_index - 1 
            where community_id = :community_id 
              and block_index > :block_index 
              and block_index < :tmp_block_index
        </querytext>
    </fullquery>

    <fullquery name="move_block_up">
        <querytext>
            update blocks_blocks 
            set block_index = block_index + 1 
            where community_id = :community_id 
              and block_index >= :tmp_block_index 
              and block_index < :block_index
        </querytext>
    </fullquery>

    <fullquery name="move_block_last">
        <querytext>
            update blocks_blocks 
            set block_index = block_index - 1 
            where community_id = :community_id 
              and block_index > :block_index 
              and block_index <= :tmp_block_index
        </querytext>
    </fullquery>

</queryset>
