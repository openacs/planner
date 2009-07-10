<?xml version="1.0"?>

<queryset>

    <fullquery name="get_parent_indent">
        <querytext>
	select indent
        from blocks_objects
        where block_id = :block_id
        and object_index < (select object_index from blocks_objects where block_object_id = :block_object_id)
        order by object_index desc
	limit 1
        </querytext>
    </fullquery>

</queryset>
