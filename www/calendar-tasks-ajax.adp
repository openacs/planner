<div style="width:10em">
<if @items:rowcount@ ne 0>
<multiple name="items">
- @items.event_name@<br>
</multiple>
</if>
<else>
#calendar.No_Items#
</else>
</div>


