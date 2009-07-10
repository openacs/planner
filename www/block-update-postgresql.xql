<?xml version="1.0"?>

<queryset>

    <fullquery name="get_block_info">
        <querytext>
            select *
            from (
                select block_id, block_index, display_p as block_display
                from blocks_blocks
                where community_id = :community_id
                and block_index <= (
                    select number_of_blocks from blocks_course_mode where community_id = :community_id )
                order by block_index) bb
            where block_index >= :first_block_index
              and block_index <= :second_block_index
        </querytext>
    </fullquery>

</queryset>
