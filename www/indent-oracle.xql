<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="get_parent_indent">
        <querytext>
	select * 
	from (select indent
            from blocks_objects
            where block_id = :block_id
	    and object_index < (select object_index from blocks_objects where block_object_id = :block_object_id)
	    order by object_index desc)
	where rownum <= 1
        </querytext>
    </fullquery>

</queryset>
