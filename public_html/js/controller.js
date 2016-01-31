//TODO: Push JSON 'title' on to path
//http://www.ajaxload.info/ for loading gifs!
var controller = {
    
    TYPE_HOME : "HOME",
    TYPE_LANDING :"LANDING",
    TYPE_CONTENT : "CONTENT",
    TYPE_CUSTOM : "CUSTOM",
    TYPE_DEFAULT : this.TYPE_CONTENT,
    
    defaultPage : "index.html",
    currentPage : null,
    currentPath : [],
    data : null,
    dataOk : false,
    loading : "/images/icons/ajax-loader-2.gif",
    
    init : function(){
        //console.log("start");
        this.loadData();
        this.loadSearchBanner();     //AJAX load
        //this.loadBannerImages();     //from JSON TODO
        this.loadCommonElements();
    },

    loadData : function(){
        $.ajax("/js/data/site-structurev2.json",
        {
            success : function(data){
                console.log("AJAX: page structure loading start");
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
                    controller.loadBreadcrumb();
                    
                    //load content panels:
                    controller.loadContentPanels();
                    
                    /*
                     * Handlers for custom pages/functions
                     */
                    switch(controller.currentPage.id){
                        case "1.3.3":   //librivox
                            //call librivox lib
                            librivox.init();  
                        
                        break;
                        case "1.6.1":
                            weddingfest07.init();
        
                            //TEST call method to load images by category and correct format:
                            
                            //console.log("LOAD CONTENTFLOW:");
                            //$("#TEST_FLOW").css({"visibility":"hidden"});
                            //$("#TEST_FLOW").addClass("ContentFlow");
                            $("#TEST_FLOW > div.panel-text").addClass("flow");
                            
                            weddingfest07.loadImagesForContentFlow(weddingfest07.EVENT_SETUP_DAY1,"#TEST_FLOW > div.panel-text");
                            
                            var myNewFlow = new ContentFlow('TEST_FLOW', { reflectionHeight: 0, circularFlow: false } ) ;
                        //console.log(myNewFlow);
                        break;
                    }
                    
                }
                else{
                    //load content not found:
                    console.log("no content");
                }
            },
            error : function(e){
                console.log(e);
            }
        });
    },

    
    loadCurrentPage : function(){
        this.currentPage = null;
        for(var a=0;a<this.data.pages.length;a++){
            //if(this.data.pages[a].url === this.getPageFilename()){ //may need to change this to include path?
            //console.log(this.data.pages[a].url + "===" + this.getRelativeUrl(true));
            if(this.data.pages[a].url === this.getRelativeUrl(true)){ //may need to change this to include path?
                this.currentPage = this.data.pages[a];
                this.dataOk = true;
            }
        }
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
        this.getPathArray();
        
        //then generate HTML:
        /*
        <div class="pure-g row-tiny border-bottom" id="breadcrumb">
            <!-- JQuery controlled background image. Set ID and image array in javascript -->
            <div class="pure-u-1 scheme-black">
                <ul>
                    <li><a href="/">Home</a><span>|</span></li>
                    <li>Landing</li>
                </ul>
            </div>
        </div>
         */
        var _outer = $(document.createElement("div")).addClass("pure-g row-tiny border-bottom").attr("id","breadcrumb");
        var _inner = $(document.createElement("div")).addClass("pure-u-1 scheme-black");
        var _ul = document.createElement("ul");
        for(var a=this.currentPath.length-1; a>=0; a--){
            //console.log(this.currentPath[a].url);
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
                //console.log(this.currentPage);
                $("title").html(this.currentPage.title);
                $(".top-bar-title").html(this.currentPage.title);

                //banner
                $(".banner-content").css({
                    "background-image":"url(" + this.currentPage.banner + ")",
                    "background-size": "contain",
                    "background-position": "left",
                    "background-repeat": "no-repeat",
                    "background-attachment":"top-left"
                });
                /*
                 * Build panels sequentially from data and inject into body area: 
                 */
                for(var a=0;a<this.currentPage.panels.length;a++){
                    $("#body-content").append(controller.buildPanel(this.currentPage.panels[a].data,pageType,a,this.data));
                }

                /*
                 * Attach the handlers once we have hte HREFs added:
                 */
                this.initLinkPanels();
            }
            else{
                console.log("no data defined for " + this.getPageFilename());
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
        if(_url === "/") _url = _url + this.defaultPage;
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

        $(document).keyup(function(evt){
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

    /*
     * Attach link handlers to panels, suppressing if link is undefined, null or #
     * Also, check that the defined URL actually exists...
     * @returns {undefined}
     */
    initLinkPanels : function(){

        //attach handlers to panels:
        $(".linkpanel").each(function(){

            var currentColour = null;
            $(this).mouseenter(function(){
                //set current background colour so we can revert on click
                currentColour = $(this).css("background-color"); 
                $(this).css("background-color","grey");
                var href = $(this).attr("data-url");
                if(href !== null 
                && href !== undefined 
                && href!== "#"){
                    $(this).css("cursor","pointer");
                }
            })
            .click(function(){
                //flash to white, and fade back to colour:
                //console.log("HREF: " + $(this).attr("data-url"));
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
            console.log("reloading...");
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
                console.log("AJAX: footer etc. loading start");
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
panelHeightClass: "row-small"
panelTypeClass: "linkpanel"
panelWidth: "1-4"
title: "section A1xx"

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
        var basePanelClass1 = null;
        var basePanelClass2 = null;
  
        //var url = this.getLinkFromId(data,panelData.linkId);
        var addLink = false;
        switch(pageType){
            case this.TYPE_HOME :
                basePanelClass1 = "pure-u-1-2 pure-u-sm-1-4 linkpanel row-small";
                addLink = true;
            break;
                
            case this.TYPE_LANDING :
                basePanelClass1 = "pure-u-1 pure-u-sm-1-2 linkpanel row";
                addLink = true;
            break;
                
            case this.TYPE_CONTENT :
                basePanelClass1 = "pure-u-1 pure-u-sm-1-4 contentpanel row";
                basePanelClass2 = "pure-u-1 pure-u-sm-3-4 contentpanel row";
            break;
        }

        var _outer = document.createElement("div");
        
        var baseClass = basePanelClass1;
        if(pageType === this.TYPE_CONTENT && panelNum > 0){
            baseClass = basePanelClass2;
        }
        
                //do we have a modifier-class?
        if(
                panelData.modifier_class !== null 
                && panelData.modifier_class !== undefined
                && panelData.modifier_class !== ""
                ){
            console.log("APPLYING CLASS " + panelData.modifier_class);
            baseClass += " " + panelData.modifier_class;
        }
        
        $(_outer).attr("class",baseClass);
        if(panelData.id !== null){
            $(_outer).attr("id",panelData.id);
        }
        if(addLink) $(_outer).attr("data-url",panelData.link);   //conditional
        $(_outer).addClass(panelData.class);
        
        
        var _title = document.createElement("div");
        $(_title).addClass("panel-title");
        
        var _headline = document.createElement("h2");
        $(_headline).html(panelData.title);
        
        var _text = document.createElement("div");
        $(_text).attr("class","panel-text");
        $(_text).html(panelData.intro);
        
        //build structure:
        _title.appendChild(_headline);
        _outer.appendChild(_title);
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
            //console.log( this.currentPath);
        }
    },
    
    getPageObjectByLinkId : function(linkId){
        var page = null;
        for(var p in this.data.pages){
            //console.log(this.data.pages[p]);
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

$(document).ajaxStart(function(){
    console.log("AJAX start " + Date.parse(new Date()));

    if(controller.getPageFilename() === "librivox.html"){
        (document.getElementsByTagName("body")[0]).appendChild(overlay);
    }
}).ajaxStop(function(){
    console.log("AJAX STOP: " + Date.parse(new Date()));
    if(controller.getPageFilename() === "librivox.html"){
        $("#overlay").remove();
        //librivox.updateDisplayPanelTitle("LibriVox");
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