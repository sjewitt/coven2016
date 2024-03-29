//TODO: Push JSON 'title' on to path
//http://www.ajaxload.info/ for loading gifs!
/*
 * "banner_scale" : "anchor", - sort out an adaptive fit or shrink
 * @type type
 * 
 * TODO: Add handler to inject link based on linkID to element?
 * 
 */
var controller = {
    
    /*
     * Definition for PAGE/PANEL objects. Use to check incoming property exists,  and also as a handy reference
     * for propertuies to use in the JSON...
     * @type type
     */
    PANEL_PROTOTYPE : {
        "title":true,                   //panel title
        "intro":true,                   //panel 
        "class":true,                   //base class to apply: scheme-xxx
        "id":true,                      //DOM ID for JQuery etc. targetting
        "link":true,                    //the HREF that the panel click will go to
        "linkId":true,                  //no longer used?
        "ajax_sub_menu_array":true,     //array of CCMS content object IDs (as string: "[1,2,3]".
        "content_id":true,              //individual CCMS content ID to render
        "modifier_class":true,          //arbitrary class to additionally apply to panel (e.g. 'panel-full-width') 
    },
    PAGE_PROTOTYPE : {
        "url":true,
        "id" : true,                    //no longer used?
        "type" : true,                  //HOME, LANDING, CONTENT
        "title" : true,                 //page title
        "banner" : true,                //URL of banner graphic
        "banner_attachment" : true,     //valid background-size css value: cover, etc. default is 'contain'
        "break":true,                   //PURE break point (defaults to 'sm'. options: sm, md, lg, xl)
        "panels" : true                 //the content panels
    },
    
    
    TYPE_HOME : "HOME",
    TYPE_LANDING :"LANDING",
    TYPE_CONTENT : "CONTENT",
    TYPE_FULLWIDTH : "FULLWIDTH",
    TYPE_CUSTOM : "CUSTOM",
    TYPE_DEFAULT : this.TYPE_CONTENT,
    
    defaultPage : "index.html",
    currentPage : null,
    currentPath : [],
    data : null,
    dataOk : false,
    loading : "/images/icons/ajax-loader-2.gif",
    
    init : function(){
        this.loadData();
        this.loadSearchBanner();     //AJAX load
        //this.loadBannerImages();     //from JSON TODO
        this.loadCommonElements();
    },

    loadData : function(){
        $.ajax("/js/data/site-structurev3.json",
        {
            success : function(data){
                /*
                 * Load data into global var:
                 */
                controller.data = data;
                
                /*
                 * Load current page:
                 */
                controller.loadCurrentPage();
                
                if(controller.dataOk){
                    /*
                     * And call dependent functions:
                     */
                    //controller.getPathArray();

                    /*
                     * load the breadcrumb
                     */
                    if(!controller.currentPage.suppress_breadcrumb){
                        controller.loadBreadcrumb();
                    }
                    //load content panels:
                    controller.loadContentPanels();
                    
                    /*
                     * Handler for CCMS content on URL hash:
                     * TODO: I need to make this dynamic. Will probably only be for subnav driven panels
                     */
                    if($("#ccms_display").length > 0){  //single panel subnav driven only. This value MUST be static for this type of output
                        var hash = window.location.hash;
                        if(hash.split(/=/)[0] === "#contentid"){
                            var contentId = hash.split(/=/)[1];
                            ccms.renderCCMSContentItem(contentId,"#ccms_display > div.panel-text","#ccms_display");
                        }
                    }
                    
                    /*
                     * Handlers for custom pages/functions that do not make their own AJAX calls:
                     */
                    switch(controller.currentPage.id){
                        case "1.3.3":   //librivox
                            //call librivox lib
                            librivox.init();  
                        
                            break;
                        case "1.6.1":
                            weddingfest07.init({displaytargetId : "content_flow_display",linksTargetId : "content_flow_links", loadContentFlow : true});

                            break;
                        case "1.3.4":
                            ccms.init();
                            break;
                        case "1.7":
                            console.log("loading wufoo form...");
                            //load wufoo contact form:
                            wufoo.init(controller.currentPage);
                            break;
                  
                    }
                    
                }
                else{
                    //load content not found:
                }
            },
            error : function(e){
                console.log(e);
            },
            complete : function(){
            	console.log('now load dynamic data.');
            	_curr = controller.data.pages[controller.getRelativeUrl(true)];
            	/*
            	 * For the current page, loop over the panels and detect one that has a dynamic AJAX call.
            	 * We need to do it here, so we can ensure the page structure has loaded based on the initial AJAX call to site structure JSON
            	 * file.
            	 * */
            	for(let a=0;a<_curr['panels'].length;a++){
            		if(_curr['panels'][a]['data']['ajax']){
            			console.log(_curr['panels'][a]['data']['ajax']);
            			controller.doCustomAjax(_curr['panels'][a]);
            		}
            	}
            	console.log()
            }
        });
    },
    
    /**
     * do custom AJAX calls once the data is completed.
     * This will overrode the default content for supplied panel:
     * */
    doCustomAjax : function(panel){
    	switch(panel['data']['ajax'].codebase){
    	case 'doomworldAPI':
    		console.log(panel);
    		idgamesengine.init(panel.data.id);
    		
    		break;
    	case 'covid19API':
    		console.log(panel);
    		covid19engine.init(panel.data.id);
    		
    		break;	
    	}
    },
    
    loadCurrentPage : function(){
        //this.currentPage = null;
        //for(var a=0;a<this.data.pages.length;a++){
            //console.log(this.getRelativeUrl(true));
            //if(this.data.pages[a].url === this.getRelativeUrl(true)){ //may need to change this to include path?
                
                //this.currentPage = this.data.pages[a];
        	this.currentPage = this.data.pages[this.getRelativeUrl(true)];
            console.log(this.currentPage);
            if(this.currentPage){
            	this.dataOk = true;
            }
                
                //*********DO SOMETHING WITH THIS???
                //var _pageOK = true;
                //for(p in this.currentPage){
                    //console.log(p+" = "+this.PAGE_PROTOTYPE[p]);
                //    if(this.PAGE_PROTOTYPE[p] === undefined){
//                        _pageOK = false;
                //    }
                //}
                //END*******************************
//               this.dataOk = true;
            //}
        //}
    },
    
    /*
     * Push search box onto all pages:
     */
    loadSearchBanner : function(){
        $.ajax("/inc/searchblock.html",
        {
            success : function(data){
                $("#search-panel").append(data);
                controller.initSearchComponents();
            }
        }
        );
    },

    loadBreadcrumb : function(){
        //load breadcrumb data:
        //console.log(this.currentPage);
        this.getPathArray();
        
        //then generate HTML:
        var _outer = $(document.createElement("div")).addClass("pure-g row-tiny border-bottom").attr("id","breadcrumb");
        var _inner = $(document.createElement("div")).addClass("pure-u-1 scheme-black");
        var _ul = document.createElement("ul");
        for(var a=this.currentPath.length-1; a>=0; a--){
            var _li = document.createElement("li");
            var _a = $(document.createElement("a")).attr("href",this.currentPath[a].url);
            var _pipe = document.createElement("span").appendChild(document.createTextNode(">"));
            var _txt = document.createTextNode(this.currentPath[a].title);
            _a[0].appendChild(_txt);
            if(a === 0){
                //text only
                _li.appendChild(_txt);
            }
            else{
                //link
                _li.appendChild(_a[0]);
                _li.appendChild(_pipe);
            }
            
            _ul.appendChild(_li);
        }
        _inner[0].appendChild(_ul);
        _outer[0].appendChild(_inner[0]);
        
        //and push as next sibling of header:
        if(this.currentPath.length > 1){
            $("#header").after(_outer);
        }
    },

    loadContentPanels : function(){

            if(this.currentPage !== undefined){
                var pageType = this.currentPage.type;
                $("title").html(this.currentPage.title);
                $(".top-bar-title").html(this.currentPage.title);

                var _imageAttachment = "contain";
                if(this.currentPage.banner_attachment && this.currentPage.banner_attachment !== null){
                    _imageAttachment = this.currentPage.banner_attachment;
                }

//TO CMPLETE
//console.log("TYPE: "+this.currentPage.type);
                //banner
                console.log(this.getRelativeUrl());
                var height = "150px";
                if(this.getRelativeUrl() === "/index.html"){
                    height = "300px";
                }
                $(".banner-content").css({
                    "background-image":"url(" + this.currentPage.banner + ")",
                    //base switch here on banner_scale: default to contain.
                    "background-size": _imageAttachment,
                    "background-position": "left",
                    "background-repeat": "no-repeat",
                    "background-attachment":"top-left",
                    "height" : height
                });
                /*
                 * Build panels sequentially from data and inject into body area: 
                 */
                for(var a=0;a<this.currentPage.panels.length;a++){
                	if(!this.currentPage.panels[a].data.disabled){
                		$("#body-content").append(controller.buildPanel(this.currentPage.panels[a].data,pageType,a,this.data));
                	}
                    
                }

                /*
                 * Attach the handlers once we have the HREFs added:
                 */
                this.initLinkPanels();
            }
            else{
                //console.log("no data defined for " + this.getPageFilename());
            }
        },

    getQueryString : function(param){
        try{
            var out = null;
            var urlStr = window.location.href;
            var qStr = urlStr.split(/\?/)[1];
            var params = qStr.split(/&/g);
            for(var a=0;a<params.length;a++){
                if(params[a].split(/=/)[0] === param){
                    out = params[a].split(/=/)[1];
                }
            }
            return out;
        }
        catch(e){
            return false;
        }
    },

    getCleanUrl : function(){
        var out = window.location.href;
        if(out.indexOf("?" !== -1)){
            out = out.split(/\?/)[0];
        };
        if(out.indexOf("#" !== -1)){
            out = out.split(/\#/)[0];
        };

        return out;
    },

    /*
     * get full relative URL. Optional 'clean' parameter will strip off request parameters.
     */
    getRelativeUrl : function(clean){
        var _url = window.location.pathname;
        //console.log(_url);
        if((_url.charAt(_url.length-1)) === "/") _url = _url + this.defaultPage;
        if(!clean) _url += window.location.search;
        return _url;
    },

    initSearchComponents : function(){

        /*
         * Start search handler
         */
        var searchterm = null;

        $("#search-btn").click(function(){
            $("#search-panel").slideDown();
        });

        $("#search-btn-close").click(function(){
            $("#search-panel").slideUp();
        });

        //search handler:
        $("#search-btn-go").hover(function(){
            $(this).css("cursor","pointer");
        }).click(function(){
            searchterm = $("#search-field").val();
            if(searchterm !== undefined && searchterm.length > 0){
                window.location.href = controller.getCleanUrl() + "?q=" + searchterm + "&showresults=true";
            }
        });

        $(document).keypress(function(evt){
        	/*
        	 * TODO: Account for currently focussed field, and also detect keypresses to
        	 * open appropriate thing... (srch vs doom search)
        	 * */
//        	console.log(evt.keyCode);
//        	if(evt.altKey){
//        		console.log('alt key pressed');
//        	}
            switch(evt.keyCode){
                case 13:        //enter
                    $("#search-btn-go").click();
                break;
                case 27:        //esc
                    $("#search-btn-close").click();
                break;
                case 83:        //'s'
                    $("#search-btn").click();
                break;
            }
        });


        //handle search result display:
        var showSearchResult = this.getQueryString("showresults");
        if(showSearchResult === "true"){

            //keep search box open:
            $("#search-btn").click();

            //populate search for with term:
            $("#search-field").val(controller.getQueryString("q"));

            //overlay search result:
            $("#search-results").dialog({
                position : {my : "left top", at:"left top",of:window},
                modal:true,
                draggable:false,
                width : $(window).width()

            });

            $(window).resize(function(){
                $("#search-results").dialog("option","width",$(window).width());
            });
        }
        /*
         * End search handler
         */
    },

    /**
     * Attach link handlers to panels, suppressing if link is undefined, null or #
     * Also, check that the defined URL actually exists...
     * @returns {undefined}
     */
    initLinkPanels : function(){

        //attach handlers to panels:
        $(".linkpanel").each(function(){
            
            /*
             * only append if teh panel has a 'link' property.
             * @type @call;$@call;css
             */
            
            var _currFontColour = null;
            var currentColour = null;
            $(this).mouseenter(function(){
                _currFontColour = $(this).css("color");
                //set current background colour so we can revert on click
                currentColour = $(this).css("background-color"); 
                $(this).css("background-color","grey");
                $(this).find("h2").css({"color":"red"});
                var href = $(this).attr("data-url");
                if(href !== null 
                && href !== undefined 
                && href!== "#"){
                    $(this).css("cursor","pointer");
                }
            })
            .click(function(){
                //flash to white, and fade back to colour:
                var href = $(this).attr("data-url");
                $(this).css("background-color","white");
                $(this).animate({
                    backgroundColor:currentColour
                },
                300,
                null,
                //see http://stackoverflow.com/questions/11693607/passing-paremeters-to-animation-callback-jquery
                function(){
                    controller.panelClickAnimateComplete(href);
                });
            })
            .mouseleave(function(){
                $(this).css("background-color",currentColour);
                $(this).css("cursor","default");
                $(this).find("h2").css({"color":_currFontColour});
            });
        });
    },

    searchSuccessHandler : function(ajaxData){
        $("#banana").html(ajaxData);
        $("#banana").dialog();

        //search engine ID: 001269262574990558717:mzdvf2ahs4w
    },

    panelClickAnimateComplete : function(href){
        if(href !== null 
                && href !== undefined 
                && href!== "#"){ //TODO: boolean check URL exists function
            window.location.href = href;
        }
        else{
            return false;
        }
    },
      
    loadCommonElements : function(){
        $.ajax("/inc/footer.html",
        {
            success:function(data){
                $("#footer").html(data);
            },
            error:function(){
                console.log("failed to load footer");
            }
        });
    },

    getPageFilename : function(){
        var filename = this.getCleanUrl().split(/\//)[this.getCleanUrl().split(/\//).length-1];
        if(filename.length === 0) filename = this.defaultPage;
        return filename;
    },
    
    /*
class: "scheme-light"
intro: "intro text intro text 1"
link: "/landing.html"
linkId: "2"
title: "title text"

Basic Structure:
<div class="pure-u-1-2 pure-u-sm-1-4 linkpanel row-small" id="panel-1">
    <div class="panel-title">
        <h2></h2>
    </div>
    <div class="panel-text"></div>
</div>

* set type (HOME,LANDING,CONTENT). This determines the basic body content layout:
*      HOME    - 1/4 width         pure-u-1-2 pure-u-sm-1-4 linkpanel row-small [scheme]
*      LANDING - 1/2 width         pure-u-1 pure-u-sm-1-2 linkpanel row [scheme]
*      CONTENT - 1/4 | 3/4 width   pure-u-1 pure-u-sm-1-4 contentpanel row [scheme]
*                                  pure-u-1 pure-u-sm-3-4 contentpanel row [scheme]

I only need panelNum on content pages to determine whether left or right panel
     */
    buildPanel : function(panelData,pageType,panelNum,data){
    	console.log(panelData);
        var basePanelClass1 = null;
        var basePanelClass2 = null;
        
        var addLink = false;
        var linkPanelClass = "";
        
        //do we have a link?
        if(panelData.link && panelData.link !== null){
            addLink = true;
            linkPanelClass = "linkpanel";
        }
  
        //02/10/16 - control media breakpoints from JSON:
        var CSSbreak = "sm";
        if(this.currentPage.break !== undefined){
            CSSbreak = this.currentPage.break;
        }
        //console.log(this.currentPage);
  
  
        //var url = this.getLinkFromId(data,panelData.linkId);
        //console.table(panelData);
        //console.log(addLink);
        switch(pageType){
            case this.TYPE_HOME :
                basePanelClass1 = "pure-u-1-2 pure-u-" + CSSbreak + "-1-4 " + linkPanelClass + " row-small";
                //addLink = true;
            break;
                
            case this.TYPE_LANDING :
                basePanelClass1 = "pure-u-1 pure-u-" + CSSbreak + "-1-2 " + linkPanelClass + " row";
                //addLink = true;
            break;
                
            case this.TYPE_CONTENT :
                basePanelClass1 = "pure-u-1 pure-u-" + CSSbreak + "-1-4 contentpanel row";
                basePanelClass2 = "pure-u-1 pure-u-" + CSSbreak + "-3-4 contentpanel row";
            break;
            
            case this.TYPE_FULLWIDTH :
                basePanelClass1 = "pure-u-1 pure-u-" + CSSbreak + "-1 contentpanel row";
            break;
        }

        var _outer = document.createElement("div");
        
        var baseClass = basePanelClass1;
        if(pageType === this.TYPE_CONTENT && panelNum > 0){
            baseClass = basePanelClass2;
        }
        
        //do we have an arbitrary modifier-class? This is defined in the JSON data
        if(
            panelData.modifier_class !== null 
            && panelData.modifier_class !== undefined
            && panelData.modifier_class !== ""
            ){
            baseClass += " " + panelData.modifier_class;
        }
        
        $(_outer).attr("class",baseClass);
        if(panelData.id !== null){
            $(_outer).attr("id",panelData.id);
        }
        if(addLink){
            $(_outer).attr("data-url",panelData.link);   //conditional
            var _a_hidden = document.createElement("a");
            _a_hidden.setAttribute("href",panelData.link);
            _outer.appendChild(_a_hidden);
        } 
        
        
        $(_outer).addClass(panelData.class);
        let _headline = null;
        let _title = null;
        if (panelData.title){
        	_title = document.createElement("div");
        	$(_title).addClass("panel-title");
        	_headline = document.createElement("h2");
        	$(_headline).html(panelData.title);
        }
        
        
        var _text = document.createElement("div");
        $(_text).attr("class","panel-text");
        
        /*
         * If intro text is omitted, convert to a narrow title bar:
         * maybe...
         * */
        if(panelData.intro === undefined){
            $(_outer).css({"min-height":"75px"});   //was height
        }
        else{
            $(_text).html(panelData.intro);
        }
        
        /*
         * Dec 2019: add hook for executing code rather than loading static content 
         * */
        
        
        /* maybe resurrect this if I build a mysql version... */
        if(panelData.content_id !== undefined){
            ccms.renderCCMSContentItem(panelData.content_id,"#"+panelData.id+" > div.panel-text","#" + panelData.id);
        }
        
        /*
         * If an array of subnav items is defined in panel, render linklist
         * get all CCMS objects matching the array:
         * 
         * I also want to handle #contentid=123 to render comtent as well.
         */
        if(panelData.ajax_sub_menu_array !== null && typeof(eval(panelData.ajax_sub_menu_array)) === "object" && panelData.ajax_sub_menu_array.length > 0){
            ccms.renderCCMSSubnav(eval(panelData.ajax_sub_menu_array),$(_text),"#ccms_display > div.panel-text","#ccms_display");
            ccms.buildSubnav = true;
        } 
        
        //build structure:
        if(_headline){
        	_title.appendChild(_headline);
        	_outer.appendChild(_title);
        }
        _outer.appendChild(_text);
        
        return(_outer);
    },
    
    /*
     * Build array of pages from self to root
     * I am making it easy for myself - n.n.n - so length/depth is
     * easy.
     * @returns {Array}
     */
    getPathArray : function(){
        if(this.currentPage !== null){
            var _currPageIdArray = this.currentPage.id.split(/\./);
            this.currentPath = [];
            for(var a = 0; a < _currPageIdArray.length; a++){
                this.currentPath.push(this.getPageObjectByLinkId(_currPageIdArray.slice(0,_currPageIdArray.length-a).join(".")));
            }
        }
    },
    
    getPageObjectByLinkId : function(linkId){
        var page = null;
        for(var p in this.data.pages){
            if(linkId === this.data.pages[p].id){
                page = this.data.pages[p];
                //add the URL - I need to sort out the JSON here!
                //page.url = p;
            }
        }
        return page;
    }
    
 
};

/*
 * Start the application:
 * @returns {undefined}
 */
$(function(){

    /*
     * Start controller:
     */
    controller.init();
});


    /*
     * build AJAX loading overlay
     */ 
    //var counter = 0;
    var overlay = document.createElement("div");
    overlay.setAttribute("id","overlay");

    var spacer = document.createElement("span");
    spacer.setAttribute("id","vertical-centerer");

    overlay.appendChild(spacer);

    var loading = document.createElement("img");
    loading.setAttribute("id","centered");

    loading.setAttribute("src",controller.loading);
    overlay.appendChild(loading);

/*
 * Maybe move this?
 * @param {type} param
 */
$(document).ajaxStart(function(){

    if(controller.getPageFilename() === "librivox.html"){
        (document.getElementsByTagName("body")[0]).appendChild(overlay);
    }
}).ajaxStop(function(){
    if(controller.getPageFilename() === "librivox.html"){
        $("#overlay").remove();
    }
});
/*
 * Google CSE code
 * https://cse.google.co.uk/cse/all
 */
  (function() {
    var cx = '001269262574990558717:mzdvf2ahs4w';
    var gcse = document.createElement('script');
    gcse.type = 'text/javascript';
    gcse.async = true;
    gcse.src = (document.location.protocol === 'https:' ? 'https:' : 'http:') +
        '//cse.google.com/cse.js?cx=' + cx;
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(gcse, s);
  })();