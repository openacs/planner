<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="update_block_mode">
        <querytext>
            update blocks_course_mode 
            set course_mode = :course_mode, number_of_blocks = :number_of_blocks, 
              start_date = (select to_date(:start_date, 'YYYY MM DD HH24 MI SS') from dual) 
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="blocks_course_mode_select">
        <querytext>
            select course_mode, number_of_blocks, 
              to_char(start_date,'YYYY MM DD') start_date 
            from blocks_course_mode 
            where community_id = :community_id
        </querytext>
    </fullquery>

</queryset>
