var old_date;
var panel;
var title="";
var tasksArray = new Array();
function showCalendarTasks(date,url,_title){
    title=_title;
    var body=document.getElementsByTagName("body")[0];
    body.className ="yui-skin-sam";
    if(old_date!=date){
        old_date="d"+date;
        if(!tasksArray[old_date]){
            var sUrl = url+'/../calendar-tasks-ajax?date='+date;
            var request = YAHOO.util.Connect.asyncRequest('GET', sUrl, {success: show_calendar_tasks});
        }else{
            panel.setBody(tasksArray[old_date]);
            panel.cfg.setProperty("context",[document.getElementById(old_date),"bl","tr"]);
        }
    }
    if(panel)
    panel.show();
}

function show_calendar_tasks(res) {
    tasksArray[old_date]=res.responseText;
    if(!panel){
        panel =  new YAHOO.widget.Panel("wait",
            { context:[old_date,"bl","tr"],              
              close:false,
              draggable:false,
              visible:true
            });
        panel.setHeader(title);
        panel.setBody(res.responseText);
        panel.render(document.body);
    }else{
        panel.setHeader(title);
        panel.setBody(res.responseText);
        panel.cfg.setProperty("context",[document.getElementById(old_date),"bl","tr"]);
    }
}

function hideCalendarTasks(){
    if(panel) panel.hide();
}
