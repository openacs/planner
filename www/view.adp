<master>
  <property name="title">@title;noquote@</property>

<link media="all" href="/resources/planner/view.css" type="text/css" rel="stylesheet"/>
<!--[if IE 6]>
<link media="all" href="/resources/planner/view-ie6.css" type="text/css" rel="stylesheet"/>
<![endif]-->
<!--[if IE 7]>
<link media="all" href="/resources/planner/view-ie.css" type="text/css" rel="stylesheet"/>
<![endif]-->

<div id="bar" style="float:left;width:210px"><br/>
  <include src="/packages/planner/lib/navbar" date="@date@">
</div>
<div id="blocks" style="/min-width: 600px;float:left;width:70%">
    <if @view@ eq "day">
      <include src="/packages/planner/lib/view-one-day-display" date="@date@"
       start_display_hour=7
       end_display_hour=22       
       package_id=@calendar_package_id@
       show_calendar_name_p=@show_calendar_name_p@>
    </if>
</div>