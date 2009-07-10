<?xml version="1.0"?>

<queryset>

    <fullquery name="planner::get_start_date.get_start_date">
        <querytext>
            select to_char(start_date, 'YYYY-MM-DD') 
            from blocks_course_mode 
            where community_id = :community_id 
        </querytext>
    </fullquery>

</queryset>
