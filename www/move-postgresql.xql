<?xml version="1.0"?>

<queryset>

    <fullquery name="get_next_block_id">
        <querytext>
        select block_id
        from (
            select block_id, block_index 
            from blocks_blocks 
            where community_id = :community_id 
            order by block_index) b
        where block_index > :block_index
        limit 1
        </querytext>
    </fullquery>

    <fullquery name="get_prev_block_id">
        <querytext>
        select block_id
        from (
            select block_id, block_index 
            from blocks_blocks 
            where community_id = :community_id 
            order by block_index desc) b
        where block_index < :block_index
        limit 1
        </querytext>
    </fullquery>

</queryset>
