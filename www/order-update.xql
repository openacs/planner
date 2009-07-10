<?xml version="1.0"?>

<queryset>

    <fullquery name="get_ids">
        <querytext>
            select block_id
            from blocks_blocks
            where block_index >= :first_block_index
              and block_index <= :second_block_index
              and community_id = :community_id
              order by block_index
        </querytext>
    </fullquery>

    <fullquery name="get_indexes">
        <querytext>
            select block_index
            from blocks_blocks
            where block_index >= :first_block_index
              and block_index <= :second_block_index
              and community_id = :community_id
              order by block_index
        </querytext>
    </fullquery>

</queryset>
