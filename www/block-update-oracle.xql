<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="get_block_info">
        <querytext>
            select *
            from (
                select block_id, block_index, display_p as block_display,
                lag(block_id)over(order by block_index) prev_block_id,
                lag(block_id)over(order by block_index desc) next_block_id
                from blocks_blocks
                where community_id = :community_id
                and block_index <= (
                    select number_of_blocks from blocks_course_mode where community_id = :community_id )
                order by block_index)
            where block_index >= :first_block_index
              and block_index <= :second_block_index
        </querytext>
    </fullquery>

</queryset>
