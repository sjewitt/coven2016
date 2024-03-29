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
class reactTest{
    let func1 = function(){
        
    }
};


var ccms = {
    
    CCMS_PROXY_URL :"/proxy/ccms_proxy.aspx",
    
    buildSubnav : false,//DEFAULT TO NOT BUILDING SUBNAV/DUMMY BC
    
    xxxbuildUI : true,
    
    xxxCCMSContent : [],   //an array of objects
    
    xxxinit : function(buildUI){
        if(buildUI === false) this.buildUI = false;

        //load all available CCMS content:
        this.loadCCMSContent();
    },
    
    loadCCMSContentxxx : function(){
        
        $.ajax(this.CCMS_PROXY_URL + "?calltype=json&listall=1",{
            
            success : function(data, textStatus, jqXHR){
                ccms.CCMSContent = data;

                if(ccms.buildUI){

                    var out = "";
                    var ul = document.createElement("ul");
                    
                    for(var p=0;p<data.length;p++){
                        if(data[p] !== null){
                            var li = document.createElement("li");
                            li.setAttribute("data-contentId",data[p].contentId);
                            li.appendChild(document.createTextNode("Item " + data[p].contentId));
                            $(li).click(function(){
                                window.localStorage.setItem("ccmsContentId",$(this).attr("data-contentId"));

                                //and set display to selected on click (oterwise it won't show until page reloaded):
                                ccms.loadCCMSContentItem($(this).attr("data-contentId"),"#ccms_output > div.panel-text");
                            }).css({"cursor":"pointer"});;
                            ul.appendChild(li);
                        }
                    }
                    $("#ccms_list > div.panel-text").append(ul);

                    if(window.localStorage.getItem("ccmsContentId")){
                        ccms.loadCCMSContentItem(window.localStorage.getItem("ccmsContentId"),"#ccms_output > div.panel-text");
                    }
                    //TODO: Do something here with AJAX-Stop, as per librivox?
                    $("#body-content>div.row").css({"height":"initial"});
                }
            },
            error : function( jqXHR, textStatus, errorThrown){
                console.log(jqXHR, textStatus, errorThrown);
            },
            complete : function(jqXHR, textStatus){}
            
        });
        
    },

    /*
     * Dependent on ALL ccms content already loaded as array.
     * @param {type} contentId
     * @param {type} target
     * @returns {undefined}
     */
    loadCCMSContentItemxxx : function(contentId,target){
        var _data = "NO DATA";
        contentId = parseInt(contentId);
        for(var p=0;p < this.CCMSContent.length;p++){
            if(this.CCMSContent[p]!== null && this.CCMSContent[p].contentId === contentId){
                _data = this.CCMSContent[p].data;
            }
        }
        
        $(target).html(_data);

    },
    
    /*
     * Stand-alone methods to get 
     */
    renderCCMSContentItem : function(contentId,target,panelId){
        //console.log(this.CCMS_PROXY_URL + "?calltype=json&contentid=" + contentId);
        
        
        
        //set the row heights to flexible:
//        console.log(target);
//        
//        console.log(panelId);
//        
//        console.log($(panelId).css({"height":""}));
//        console.log($(target).css({"height":""}));
//        console.log($(panelId).parent().parent());
//        
        
                   console.log("setting height to null");     
                $("#body-content.row").css({"height":"", "color":"green"});

                //$("#body-content.row").css({"height":""});
        
        $.ajax(this.CCMS_PROXY_URL + "?calltype=json&contentid=" + contentId,{
            
            success : function(data, textStatus, jqXHR){
                
                /*
                 * TinyMCE uses relative notation for image paths ../ etc.
                 * Simplest way is to hack the path until I figure out a way to 
                 * get CCMS to render fixed partial paths /img/ etc.
                 */
                data.data = $.parseHTML(data.data);
                
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
                
                $(target).html(data.data);
                //$("#body-content>div.row").css({"min-height":"300px","height":"initial"});
                
                //push the title onto the HTML title and the main headings:
                $("title").text(data.name);

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


