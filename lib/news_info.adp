
<multiple name="news">
  <if @news.rownum@ lt @max@>
    <div class="news">
     <p>
     <a href="../news/item?item_id=@news.item_id@"><strong>@news.publish_title@</strong></a><br>
    @news.publish_body@</p>
  <div class="bottomnews"></div>
    </div>
  </if>
  <if @news.rownum@ eq @max@>
    <div class="news">
     <p>
     <a href="../news/item?item_id=@news.item_id@"><strong>@news.publish_title@</strong></a><br>
    @news.publish_body@</p>
    </div>
  </if>
</multiple>