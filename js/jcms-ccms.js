/*
 * TODO:
 * Amend REST calls to return more complex objects:
 * Content >
 *  - ContentInstance[]
 *  
 *  
 *  **** re do this with single load on first page load!! ****
 *  I ONLY WANT TO LOAD THE AJAX STUFF ONCE. I CAN THEN
 *  PULL OUT THE RELEVANT ITEMS FROM THE LOADED DATA
 *  
 */

var ccms = {
    
    CCMS_PROXY_URL :"/proxy/ccms_proxy.aspx", ///ccms.aspx",
    
    buildSubnav : false,//DEFAULT TO NOT BUILDING SUBNAV/DUMMY BC
    
    /*
     * Stand-alone methods to get 
     */
    renderCCMSContentItem : function(contentId,target,panelId){
        $.ajax(this.CCMS_PROXY_URL + "?calltype=json&contentid=" + contentId,{
            
            success : function(data, textStatus, jqXHR){
                
                /*
                 * TinyMCE uses relative notation for image paths ../ etc.
                 * Simplest way is to hack the path until I figure out a way to 
                 * get CCMS to render fixed partial paths /img/ etc.
                 */
                data.data = $.parseHTML(data.data);
                //console.log(data.data);
                if(data.data !== null && data.data.length > 0){
                    for(var a=0;a<data.data.length;a++){
                        $(data.data[a]).find("img").each(function(){
                            $(this).attr("src","/" + $(this).attr("src").replace(/\.\.\//g,""));
                        });
                        $(data.data[a]).find("a").each(function(){
                            //because we have internal anchors sometimes
                            if($(this).attr("href") && $(this).attr("href").indexOf("#contentid=") !== -1){
                                try{
                                    $(this).click(function(){
                                        ccms.renderCCMSContentItem($(this).attr("href").split(/#contentid=/)[1],target,panelId);
                                    });
                                }
                                catch(e){}

                            }
                        });
                    }
                }
                $(target).html(data.data);
                $("#body-content>div.row").css({"min-height":"300px","height":"initial"});
                
                //push the title onto the HTML title and the main headings:
                //Doesn't work if > 1 panel has content. We end up with the last panel title...
                //$("title").text(data.name);

                $(panelId+">div.panel-title>h2").text(data.name); 
                    
                if(ccms.buildSubnav){
                    //the section onto the breadcrumb, unless disabled in configuration JSON file:
                    ccms.extendBreadcrumb(data.name);
                }
            }
        });
    },
    
    /*
     * Build list of subnav items with corresponding click handlers:
     * can have a string ID or JQobj identifier
     */
    renderCCMSSubnav : function(contentIdArray,subnavDisplayTarget,subnavContentRenderTarget,panelId){
        var ul = document.createElement("ul");
        $(ul).addClass("panel-sub-menu");
        if(typeof(subnavDisplayTarget) === "object"){;
            $(subnavDisplayTarget).append(ul);
        }
        else{
            $("#" + subnavDisplayTarget).append(ul);
        }
        
        //get ALL content:
        $.ajax(this.CCMS_PROXY_URL + "?calltype=json&listall=true",{
            success : function(data, textStatus, jqXHR){
                var counter = 0;
                for(var b=0;b<contentIdArray.length;b++){   //because we want the order as defined in the configured array
                    for(var a=0;a<data.length;a++){
                        if(data[a] !== null && data[a].contentId === contentIdArray[b]){
                            if(typeof(subnavDisplayTarget) === "object"){
                                $(subnavDisplayTarget).find("ul").append(ccms.buildCCMSSubnavLink(data[a],subnavContentRenderTarget,panelId,counter));
                            }
                            else{
                                $("#" + subnavDisplayTarget).find("ul").append(ccms.buildCCMSSubnavLink(data[a],subnavContentRenderTarget,panelId,counter));
                            }
                        }
                    }
                    counter++;
                }
            }
        });
    },
    
    /*
     * Build a link from the CCMS ContentInstance data:
     */
    buildCCMSSubnavLink : function(data,target,panelId,itemIndex){
        console.log(itemIndex)
        var _li = document.createElement("li");
        if(itemIndex === 0){
            $(_li).css({"font-weight":"bold"}); //default first to highjlighted
        }
        _li.setAttribute("data-content-id",data.contentId);
        _li.appendChild(document.createTextNode(data.name));
        $(_li).css({"cursor":"pointer"});
        
        /*
         * Add click handler to push the content onto the display area:
         */
        $(_li).click(function(){
            //clear existing bold:
            $(this).parent().find("li").each(function(){
                $(this).css({"font-weight":""})
            });
            
            $(this).css({"font-weight":"bold"});
            ccms.renderCCMSContentItem($(this).attr("data-content-id"),target,panelId);
        });
        return _li;
    },
    
    /*
     * push a new virtual item onto the end of the BC.
     * Make prior item a link. This is to facilitate the 
     * virtual navigation if so configured
     */
    extendBreadcrumb : function(linktext){
        //get current page base URL:
        var _url = controller.getCleanUrl();
        
        //remove any pushed in items
        $("#breadcrumb").find("li").each(function(){
            if($(this).attr("style")){
                $(this).next().remove();
            }
        });
        
        var _BCTip = $("#breadcrumb").find("li").last();
        _BCTip.click(function(){document.location = _url;});
        $(_BCTip).css({"cursor":"pointer"});
        $(_BCTip).parent().append("<li> > "+linktext+"</li>");
    }
};


