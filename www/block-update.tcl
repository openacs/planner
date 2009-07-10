ad_page_contract {
    Update the object when moved to another block

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date Jul-2008
} {
    {block_index1 0}
    {block_index2 0}
}

set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]

if { $block_index1 > $block_index2 } {
    set first_block_index $block_index2
    set second_block_index $block_index1
} else {
    set first_block_index $block_index1
    set second_block_index $block_index2
}

db_multirow get_blocks get_block_info { *SQL* } {}