
<div class="portlet">
  <div id="div_1" class="sub_bar">
    <div id="header_1" class="header"> 
     <div class="title_bar">#planner.activities#</div>
     <div class="image"><a id="link_1" href="javascript:hideMenu(1)"><img id="img_1" src="/resources/planner/minus.gif" alt="minus" /></a></div>
     <div style="clear:both"></div>
    </div>
    <div id="content_1" class="content"><br>
     <ul>
      <if @pages_p@><li><a href="@return_url@/planner/" alt="#dotlrn.class_page_home_title#">#dotlrn.class_page_home_title#</a></li></if>
      <if @assessment_p@><li><a href="@return_url@/assessment/" alt="#assessment.Assessment#">#assessment.Assessment#</a></li></if>
      <if @assessment_p@><li><a href="@return_url@/view-portlet?name=evaluation_assignments_portlet" alt="#evaluation.Assignments#">#evaluation.Assignments#</a></li></if>
      <if @evaluation_p@><li><a href="@return_url@/view-portlet?name=evaluation_evaluations_portlet" alt="#evaluation.Evaluations#">#evaluation.Evaluations#</a></li></if>
      <if @chat_p@><li><a href="@return_url@/chat/" alt="#chat.Chat#">#chat.Chat#</a></li></if>
      <if @learning_content_p@><li><a href="@return_url@/learning-content/" alt=#learning-content.content#">#learning-content.content#</a></li></if>
      <if @forums_p@><li><a href="@return_url@/forums/" alt="#forums.Forum#">#forums.Forum#</a></li></if>
     </ul>
    </div>
  </div>
  <div id="div_2" class="sub_bar">
    <div id="header_2" class="header"> 
     <div class="title_bar">#planner.calendar#</div>
     <div class="image"><a id="link_2" href="javascript:hideMenu(2)"><img id="img_2" src="/resources/planner/minus.gif" alt="minus" /></a></div>
     <div style="clear:both"></div>
    </div>
    <div id="content_2" class="content" align=center>
       <include src="/packages/planner/lib/mini-calendar" base_url="@return_url@/planner/view" view="day" date="@date@">
    </div>
  </div>
  <if @admin_p@>
  <div id="div_3" class="sub_bar">
    <div id="header_3" class="header"> 
      <div class="title_bar">#dotlrn.lt_Administrative_Action#</div>
      <div class="image"><a id="link_3" href="javascript:hideMenu(3)"><img id="img_3" src="/resources/planner/minus.gif" alt="minus" /></a></div>
      <div style="clear:both"></div>
    </div>
    <div id="content_3" class="content"><br>
        <ul>
          <li><a href="@return_url@/one-community-admin" alt="dotlrn.Administration">#planner.administration#</a></li>
          <li><a href="@return_url@/subcommunity-new" alt="#dotlrn-portlet.New_sub_pretty_name#">#dotlrn-portlet.New_sub_pretty_name#</a>
      <if @evaluation_p@>
          <li><a href="@return_url@/evaluation/admin/" alt="#evaluation.Evaluations_Admin#">#evaluation.Evaluations_Admin#</a></li>
      </if>
      <if @assessment_p@>
          <li><a href="@return_url@/assessment/asm-admin/assessment-form?type=test" alt="#assessment.New_Assessment#">#assessment.New_Assessment#</a></li>
      </if>
      <if @learning_content_p@>
          <li><a href="@return_url@/learning-content/content-admin/" alt="Admin Content">Admin Content</a></li>
      </if>
      <li><a href="@return_url@/spam-recipients?referer=planner/"alt="#dotlrn.Compose_bulk_message#">#dotlrn.Compose_bulk_message#</a>
      <if @forums_p@>
          <li><a href="@return_url@/forums/admin/forum-new" alt="#forums.New_Forum#">#forums.New_Forum#</a></li>
      </if>
      <if @faq_p@>
          <li><a href="@return_url@/faq/admin/faq-new" alt="#faq-portlet.new_faq#">#faq-portlet.new_faq#</a></li>
      </if>
      <if @static_portlet_p@>
          <li><a href="/dotlrn/applets/static-portlet/element?portal_id=@portal_id@&referer=@community_url@" alt="#dotlrn-static.class_info_portlet_pretty_name#">#static-portlet.New# #dotlrn-static.class_info_portlet_pretty_name#</a></li>
      </if>
      <if @chat_p@>
          <li><a href="@return_url@/chat/room-edit" alt="New Forum">New Chat Room</a></li>
      </if>
        </ul>
    </div>
  </div>
  </if>
  <if @news_p@>
  <div id="div_4" class="sub_bar">
    <div id="header_4" class="header"> 
     <div class="title_bar">#planner.news#</div>
     <div class="image"><a id="link_4" href="javascript:hideMenu(4)"><img id="img_4" src="/resources/planner/minus.gif" alt="minus" /></a></div>
     <div style="clear:both"></div>
    </div>
    <div id="content_4" class="content"><br>
        <if @admin_p@>&nbsp;<a href="../news/item-create">#news.Create_News_Item#</a><br></if>
       <include src="/packages/planner/lib/news_info"  community_id="@community_id@" max="2">
    </div>
  </div>
  </if>
</div>

