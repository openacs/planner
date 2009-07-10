<?xml version="1.0"?>

<queryset>

    <fullquery name="delete_block_object">
        <querytext>
            delete from blocks_objects 
            where block_object_id = :block_object_id
        </querytext>
    </fullquery>

    <fullquery name="check_object">
        <querytext>
        select count(*) 
	from blocks_objects 
	where object_id = :object_id
        </querytext>
    </fullquery>

</queryset>
