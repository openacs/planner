var Dom = YAHOO.util.Dom;
var Event = YAHOO.util.Event;
var DDM = YAHOO.util.DragDropMgr;
// Information about the start drag point: parentNode, position, index in parentNode
var blocks_index_map = new Array();
var startParentEl, startPos, startIndex, startLast;
var load_img = document.createElement('img');
load_img.id = 'indicator';
load_img.src = '/resources/planner/indicator.gif';

function getElementsByClassName(classname, node) {
    if(!node) node = document.getElementsByTagName("body")[0];
    var a = [];
    var re = new RegExp('\\b' + classname + '\\b');
    var els = node.getElementsByTagName("*");
    for(var i=0,j=els.length; i<j; i++)
    if(re.test(els[i].className))a.push(els[i]);
    return a;
}

function findNodePosition(node, id, liClass) {
    var items = getElementsByClassName(liClass,node);
    if (items.length > 1) {
        for (i=0;i<items.length;i++) {
            if (items[i].id == id) {
                if ( i + 1 < items.length ) {
                    return getId(items[i+1].id);
                } else {
                    return getId(items[i-1].id);
                }
            }
        }
    } else {
        return 0;
    }
}

function findNodeIndex(node, id) {
    var items = getElementsByClassName("block-li",node);
    if (items.length > 1) {
        for (i=0;i<items.length;i++) {
            if (items[i].id == id) {
                return i;
            }
        }
    } else {
        return 0;
    }
}

function getId(name) {
    var objects = name.split('_');
    return objects[objects.length - 1];
}

function isLastNode(node, id, liClass) {
    var items = getElementsByClassName(liClass,node);
    if (items[items.length - 1].id == id) {
        return 1;
    } else {
        return 0;
    }
}

function insertNodeByPos(parent, src, destPos, isLast, liClass) {
    if (destPos != 0) {
        var dest = 0;
        var items = getElementsByClassName(liClass,parent);
        for (i=0;i<items.length;i++) {
            if (getId(items[i].id) == destPos) {
                var dest = i;
                break;
            }
        }
        var dest = items[dest];
        if (isLast) { dest = dest.nextSibling; }
        if (items.length > 0) {
            parent.insertBefore(src,dest);
            return 1;
        } else {
            return 0;
        }
    } else {
        parent.appendChild(src);
    }
}

YAHOO.example.DDApp = {
    init: function() {
        var blocks = blocks_list.split(',');
        var blocks_index = blocks_index_list.split(',');
        var objects = objects_list.split(',');
        for ( var i = 0; i < blocks.length ; i++ ){
            blocks_index_map[blocks[i]] = blocks_index[i];
        }
        for ( var i = 0; i < blocks.length ; i++ ){
            new YAHOO.util.DDTarget("blocklist_"+blocks[i],"objects_list");
        }
        new YAHOO.util.DDTarget("blocklist","blocks_list");
        for ( var i = 1; i < blocks.length ; i++ ){
            var bl_tmp = new YAHOO.example.DDBlockList("blockli_"+blocks[i],"blocks_list", {cont: 'blocks'});
            bl_tmp.setHandleElId("move_block_"+blocks[i]);
            bl_tmp.setHandleElId("move_block2_"+blocks[i]);
        }
        for ( var i = 0; i < objects.length ; i++ ){
            var bo_tmp = new YAHOO.example.DDList("blockobject_" + objects[i],"objects_list", {cont: 'blocks'} );
            bo_tmp.setHandleElId("move_object_"+objects[i]);
        }
    }

};

YAHOO.example.DDList = function(id, sGroup, config) {

    this.cont = config.cont;
    YAHOO.example.DDList.superclass.constructor.call(this, id, sGroup, config);

    this.logger = this.logger || YAHOO;
    var el = this.getDragEl();
    Dom.setStyle(el, "opacity", 0.67); // The proxy is slightly transparent

    this.goingUp = false;
    this.lastY = 0;
};

YAHOO.extend(YAHOO.example.DDList, YAHOO.util.DDProxy, {
    cont: null,
    init: function() {
        //Call the parent's init method
        YAHOO.example.DDList.superclass.init.apply(this, arguments);
        this.initConstraints();

        Event.on(window, 'resize', function() {
            this.initConstraints();
        }, this, true);
    },
    initConstraints: function() {
        //Get the top, right, bottom and left positions
        var region = Dom.getRegion(this.cont);

        //Get the element we are working on
        var el = this.getEl();

        //Get the xy position of it
        var xy = Dom.getXY(el);

        //Get the width and height
        var width = parseInt(Dom.getStyle(el, 'width'), 10);
        var height = parseInt(Dom.getStyle(el, 'height'), 10);

        //Set left to x minus left
        var left = xy[0] - region.left;

        //Set right to right minus x minus width
        var right = region.right - xy[0] - width;

        //Set top to y minus top
        var top = xy[1] - region.top;

        //Set bottom to bottom minus y minus height
        var bottom = region.bottom - xy[1] - height;

        //Set the constraints based on the above calculations
        this.setXConstraint(left, right);
        this.setYConstraint(top, bottom);
    },

    startDrag: function(x, y) {
        this.logger.log(this.id + " startDrag");
        // make the proxy look like the source element
        var dragEl = this.getDragEl();
        var clickEl = this.getEl();
        startParentEl = clickEl.parentNode;
        Dom.setStyle(clickEl, "visibility", "hidden");
        startIndex = findNodePosition(startParentEl,clickEl.id,"block-li");
        startPos = Dom.getXY(clickEl);
        startLast = isLastNode(startParentEl,clickEl.id,"block-li");

        dragEl.innerHTML = clickEl.innerHTML;

        Dom.setStyle(dragEl, "color", Dom.getStyle(clickEl, "color"));
        Dom.setStyle(dragEl, "backgroundColor", Dom.getStyle(clickEl, "backgroundColor"));
        Dom.setStyle(dragEl, "border", "2px solid gray");
    },

    endDrag: function(e) {

        var srcEl = this.getEl();
        var proxy = this.getDragEl();
        if (DDM.interactionInfo.validDrop) { var destPos = Dom.getXY(srcEl); } else { var destPos = startPos; }
        // Show the proxy element and animate it to the src element's location
        Dom.setStyle(proxy, "visibility", "");
            var a = new YAHOO.util.Motion( 
                proxy, { 
                    points: { 
                        to: destPos
                    }
                }, 
                0.2, 
                YAHOO.util.Easing.easeOut 
            );
        var proxyid = proxy.id;
        var thisid = this.id;

        // Hide the proxy and show the source element when finished with the animation
        a.onComplete.subscribe(function() {
                Dom.setStyle(proxyid, "visibility", "hidden");
                Dom.setStyle(thisid, "visibility", "");
            });
        a.animate();
        if (DDM.interactionInfo.validDrop) {
            var to_block_id = getId(srcEl.parentNode.id);
            var start_block_id = getId(startParentEl.id);
            var block_object_id = getId(srcEl.id);
            var tmp_block_object_id = findNodePosition(srcEl.parentNode,srcEl.id,"block-li");
            var to_block = isLastNode(srcEl.parentNode,srcEl.id,"block-li");
            if ( tmp_block_object_id == 0 ) { var tmp_object_index = 1; } else { var tmp_object_index = 0; }
            var url = community_url+'planner/objects-move?to_block_id='+to_block_id+'&tmp_object_index='+tmp_object_index+'&block_object_id='+block_object_id+'&to_block='+to_block+'&tmp_block_object_id='+tmp_block_object_id;
            new Ajax.Request(url, {method: 'get', onLoading: function(){ srcEl.appendChild(load_img); }, 
						  onSuccess: function (r) { 
							if(srcEl.getAttribute('rel') == "t" && srcEl.parentNode.getAttribute('rel') == "t"){ 
								srcEl.setAttribute("class","block-li"); 
								srcEl.setAttribute("className","block-li"); 
								new Ajax.Request(community_url+'planner/object-update?block_object_id='+block_object_id+'&block_id='+to_block_id,{method: 'get', 
									onSuccess: function(r){ srcEl.innerHTML = r.responseText }});
							}
							if(srcEl.getAttribute('rel') == "t" && srcEl.parentNode.getAttribute('rel') == "f"){
								srcEl.setAttribute("class","object-hidden block-li");
								srcEl.setAttribute("className","object-hidden block-li");
								new Ajax.Request(community_url+'planner/object-update?block_object_id='+block_object_id+'&block_id='+to_block_id,{method: 'get', 
									onSuccess: function(r){ srcEl.innerHTML = r.responseText }});
							}
							 }, 
						  onComplete: function(){ srcEl.removeChild(load_img); } });
        } else {
            insertNodeByPos(startParentEl,srcEl,startIndex,startLast,"block-li");
        }
    },

    onDragDrop: function(e, id) {

        // If there is one drop interaction, the li was dropped either on the list,
        // or it was dropped on the current location of the source element.
        if (DDM.interactionInfo.drop.length === 1) {

            // The position of the cursor at the time of the drop (YAHOO.util.Point)
            var pt = DDM.interactionInfo.point; 

            // The region occupied by the source element at the time of the drop
            var region = DDM.interactionInfo.sourceRegion; 

            // Check to see if we are over the source element's location.  We will
            // append to the bottom of the list once we are sure it was a drop in
            // the negative space (the area of the list without any list items)
            if (!region.intersect(pt)) {
                var destEl = Dom.get(id);
                var destDD = DDM.getDDById(id);
                destEl.appendChild(this.getEl());
                destDD.isEmpty = false;
                DDM.refreshCache();
            }

        }
    },

    onDrag: function(e) {

        // Keep track of the direction of the drag for use during onDragOver
        var y = Event.getPageY(e);

        if (y < this.lastY) {
            this.goingUp = true;
        } else if (y > this.lastY) {
            this.goingUp = false;
        }

        this.lastY = y;
    },

    onDragOver: function(e, id) {
    
        var srcEl = this.getEl();
        var destEl = Dom.get(id);

        // We are only concerned with list items, we ignore the dragover
        // notifications for the list.
        if (destEl.nodeName.toLowerCase() == "li") {
            var orig_p = srcEl.parentNode;
            var p = destEl.parentNode;
            if (this.goingUp) {
                nextEl = destEl;
                p.insertBefore(srcEl, destEl); // insert above
            } else {
                nextEl = destEl.nextSibling;
                p.insertBefore(srcEl, destEl.nextSibling); // insert below
            }

            DDM.refreshCache();
        }
        var dragEl = this.getDragEl();
        Dom.setStyle(dragEl, "border", "2px solid red");

    },

    onDragOut: function(e, id) {
    
        var dragEl = this.getDragEl();
        Dom.setStyle(dragEl, "border", "2px solid gray");

    }
});

YAHOO.example.DDBlockList = function(id, sGroup, config) {

    this.cont = config.cont;
    YAHOO.example.DDBlockList.superclass.constructor.call(this, id, sGroup, config);

    this.logger = this.logger || YAHOO;
    var el = this.getDragEl();
    Dom.setStyle(el, "opacity", 0.1); // The proxy is slightly transparent

    this.goingUp = false;
    this.lastY = 0;

};

YAHOO.extend(YAHOO.example.DDBlockList, YAHOO.util.DDProxy, {
    cont: null,
    init: function() {
        //Call the parent's init method
        YAHOO.example.DDBlockList.superclass.init.apply(this, arguments);
        this.initConstraints();

        Event.on(window, 'resize', function() {
            this.initConstraints();
        }, this, true);
    },
    initConstraints: function() {
        //Get the top, right, bottom and left positions
        var region = Dom.getRegion(this.cont);

        //Get the element we are working on
        var el = this.getEl();

        //Get the xy position of it
        var xy = Dom.getXY(el);

        //Get the width and height
        var width = parseInt(Dom.getStyle(el, 'width'), 10);
        var height = parseInt(Dom.getStyle(el, 'height'), 10);

        //Set left to x minus left
        var left = xy[0] - region.left;

        //Set right to right minus x minus width
        var right = region.right - xy[0] - width;

        //Set top to y minus top
        var top = xy[1] - region.top;

        //Set bottom to bottom minus y minus height
        var bottom = region.bottom - xy[1] - height;

        //Set the constraints based on the above calculations
        this.setXConstraint(left, right);
        this.setYConstraint(top, bottom);
    },

    startDrag: function(x, y) {
        this.logger.log(this.id + " startDrag");

        // make the proxy look like the source element
        var dragEl = this.getDragEl();
        var clickEl = this.getEl();
        startParentEl = clickEl.parentNode;
        startIndex = findNodePosition(startParentEl,clickEl.id,"blocklist-li");
        startPos = Dom.getXY(clickEl);
        startLast = isLastNode(startParentEl,clickEl.id,"blocklist-li");

        dragEl.innerHTML = "";

        Dom.setStyle(document.getElementById('div_'+getId(clickEl.id)),"visibility","hidden");

        Dom.setStyle(document.getElementById('block_'+getId(clickEl.id)), "border", "2px dotted blue");
        Dom.setStyle(dragEl, "color", Dom.getStyle(clickEl, "color"));
        Dom.setStyle(dragEl, "border", "2px solid gray");
    },

    endDrag: function(e) {

        var srcEl = this.getEl();
        var proxy = this.getDragEl();
        if (DDM.interactionInfo.validDrop) { var destPos = Dom.getXY(srcEl); } else { var destPos = startPos; }
        // Show the proxy element and animate it to the src element's location
        Dom.setStyle(proxy, "visibility", "");
            var a = new YAHOO.util.Motion( 
                proxy, { 
                    points: { 
                        to: destPos
                    }
                }, 
                0.2, 
                YAHOO.util.Easing.easeOut 
            );
        var proxyid = proxy.id;
        var thisid = this.id;

        // Hide the proxy and show the source element when finished with the animation
        a.onComplete.subscribe(function() {
                Dom.setStyle(proxyid, "visibility", "hidden");
                Dom.setStyle(thisid, "border", "0");
                Dom.setStyle(document.getElementById('block_'+getId(srcEl.id)), "border", "0");
                Dom.setStyle(document.getElementById('div_'+getId(srcEl.id)),"visibility","");
            });
        a.animate();
        if (DDM.interactionInfo.validDrop) {
            var block_id = getId(srcEl.id);
            var tmp_block_id = findNodePosition(srcEl.parentNode,srcEl.id,"blocklist-li");
            var isLast = isLastNode(srcEl.parentNode,srcEl.id,"blocklist-li");
            var url = community_url+'planner/move?block_id='+block_id+'&tmp_block_id='+tmp_block_id+'&last_p='+isLast+'&swap_p=0';
            var update_url = community_url+'planner/order-update?block_index1='+blocks_index_map[block_id]+'&block_index2='+blocks_index_map[tmp_block_id]+'&dates_p='+dates;
            var update_blocks_options = community_url+'planner/block-update?block_index1='+blocks_index_map[block_id]+'&block_index2='+blocks_index_map[tmp_block_id];
//            var update_tmp_block_options = community_url+'block-update?block_id='+tmp_block_id;
            new Ajax.Request(url, {
                method: 'get', 
                onLoading: function(){ srcEl.appendChild(load_img); }, 
                onComplete: function(){ srcEl.removeChild(load_img); }, 
                onSuccess: function(r){
                    new Ajax.Request(update_url,{
                        method: 'get', 
                        onSuccess: function(r){
                            var blocks_index_id = r.responseText.split(';');
                            var blocks_ids = blocks_index_id[0].split(',');
                            if(blocks_index_id[3] > 0) {
                                var current_week = getElementsByClassName("current-block",document);
                                var classes = current_week[0].className.split(' ');
                                for(j=0;j<classes.length;j++) {
                                    if(classes[j] == 'current-block'){
                                        classes.splice(j,1);
                                    }
                                }
                                var new_class = classes.join(" ");
                                for(i=0;i<current_week.length;i++) { 
                                    current_week[i].className = new_class;
                                }
                                var obj1 = document.getElementById('move_block_'+blocks_index_id[3]);
                                var obj2 = document.getElementById('move_block2_'+blocks_index_id[3]);
                                obj1.className = obj1.className + " current-block";
                                obj2.className = obj2.className + " current-block";
                            }
                            var blocks_indexes = blocks_index_id[2].split(',');
                            if ( dates == 1 ) { 
                                var blocks_dates = blocks_index_id[1].split(',');
                                for (i=0;i<blocks_ids.length;i++){
                                    blocks_index_map[blocks_ids[i]] = blocks_indexes[i];
                                    document.getElementById('block_date_'+blocks_ids[i]).innerHTML = blocks_dates[i];
                                }
                            } else {
                                for (i=0;i<blocks_ids.length;i++){
                                    blocks_index_map[blocks_ids[i]] = blocks_indexes[i];
                                    document.getElementById('block_index_'+blocks_ids[i]).innerHTML = blocks_indexes[i];
                                }
                            }
                            new Ajax.Request(update_blocks_options,{
                                method: 'get', 
                                onSuccess: function(r){ 
                                    var blocks_options = r.responseText.split('-----');
                                    for (i=0;i<blocks_options.length;i++) {
                                        document.getElementById('move_block2_'+blocks_ids[i]).innerHTML = blocks_options[i];
                                    }
                                }});
                        }});
                } });
        } else {
            insertNodeByPos(startParentEl,srcEl,startIndex,startLast,"blocklist-li");
        }
    },

    onDragDrop: function(e, id) {
        // If there is one drop interaction, the li was dropped either on the list,
        // or it was dropped on the current location of the source element.
        if (DDM.interactionInfo.drop.length === 1) {

            // The position of the cursor at the time of the drop (YAHOO.util.Point)
            var pt = DDM.interactionInfo.point; 

            // The region occupied by the source element at the time of the drop
            var region = DDM.interactionInfo.sourceRegion; 

            // Check to see if we are over the source element's location.  We will
            // append to the bottom of the list once we are sure it was a drop in
            // the negative space (the area of the list without any list items)
            if (!region.intersect(pt)) {
                var destEl = Dom.get(id);
                var destDD = DDM.getDDById(id);
                destEl.appendChild(this.getEl());
                destDD.isEmpty = false;
                DDM.refreshCache();
            }

        }
    },

    onDrag: function(e) {

        // Keep track of the direction of the drag for use during onDragOver
        var y = Event.getPageY(e);

        if (y < this.lastY) {
            this.goingUp = true;
        } else if (y > this.lastY) {
            this.goingUp = false;
        }

        this.lastY = y;
    },

    onDragOver: function(e, id) {
    
        var srcEl = this.getEl();
        var destEl = Dom.get(id);

        if (destEl.nodeName.toLowerCase() == "li") {
            var orig_p = srcEl.parentNode;
            var p = destEl.parentNode;
            if (this.goingUp) {
                nextEl = destEl;
                p.insertBefore(srcEl, destEl); // insert above
            } else {
                nextEl = destEl.nextSibling;
                p.insertBefore(srcEl, destEl.nextSibling); // insert below
            }

            DDM.refreshCache();
        }

        var dragEl = this.getDragEl();
        Dom.setStyle(dragEl, "border", "2px solid red");
    },

    onDragOut: function(e, id) {
    
        var dragEl = this.getDragEl();
        Dom.setStyle(dragEl, "border", "2px solid gray");

    }
});
if (edit_mode == '1') {
Event.onDOMReady(YAHOO.example.DDApp.init, YAHOO.example.DDApp, true);
}
