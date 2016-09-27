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

var defaultPage = "index.html";
var BannerMap = [
    {id:"content-identifier-x",img:"/images/css/beaker-neg.png"}//move to JSON
];

    
$(function(){    //load banners:
    loadContentPanels();    //from JSON
    
    loadBannerImages(); //from JSON TODO
    
    loadCommonElements();
    
    initSearchComponents();
    
    

});
//content-identifierXX
///images/css/Haunted-House2.png
function loadBannerImages(){
    for(var a=0;a<BannerMap.length;a++){
        $("#" + BannerMap[a].id).css({
            "background-image":"url(" + BannerMap[a].img + ")",
            "background-size": "contain",
            "background-position": "left",
            "background-repeat": "no-repeat"
        });
    }
}

function getQueryString(param){
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
}

function getCleanUrl(){
    var out = window.location.href;
    if(out.indexOf("?"!== -1)){
        out = out.split(/\?/)[0];
    };
    if(out.indexOf("#"!== -1)){
        out = out.split(/\#/)[0];
    };
    
    return out;
}


function initSearchComponents(){
        
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
            window.location.href = getCleanUrl() + "?q=" + searchterm + "&showresults=true";
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
    var showSearchResult = getQueryString("showresults");
    if(showSearchResult === "true"){

        //keep search box open:
        $("#search-btn").click();
        
        //populate search for with term:
        $("#search-field").val(getQueryString("q"));
        
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
}

function initLinkPanels(){
    
    //attach handlers to panels:
    $(".linkpanel").each(function(){
        
        var currentColour = null;
        $(this).mouseenter(function(){
            //set current background colour so we can revert on click
            currentColour = $(this).css("background-color"); 
            $(this).css("background-color","grey");
            $(this).css("cursor","pointer");
        })
        .click(function(){
            //flash to white, and fade back to colour:
            var href = $(this).attr("url");
            $(this).css("background-color","white");
            $(this).animate({
                backgroundColor:currentColour
            },
            300,
            null,
            //see http://stackoverflow.com/questions/11693607/passing-paremeters-to-animation-callback-jquery
            function(){
                panelClickAnimateComplete(href);
            });
        })
        .mouseleave(function(){
            $(this).css("background-color",currentColour);
            $(this).css("cursor","default");
        });
    });
}

function searchSuccessHandler(ajaxData){
    console.log("AJAXDATA: "+ajaxData);
    $("#banana").html(ajaxData);
    $("#banana").dialog();
    
    //search enginhe ID: 001269262574990558717:mzdvf2ahs4w
}

function panelClickAnimateComplete(href){
    window.location.href = href;
}
        
function loadContentPanels(){
    $.ajax("/js/data/site-structurev2.json",
    {
        success:function(data){
            /*
             * Get page data from page data array JSON
             * @type @exp;data@arr;pages
             */
            var pageData = data.pages[getPageFilename()];
            console.log(getPageFilename());
            if(pageData !== undefined){
                /*
                    .scheme-black
                    .scheme-vlight{
                    .scheme-light{
                    .scheme-mid{
                    .scheme-dark{
                    .scheme-vdark
                 */
                console.log("PAGE TITLE "+pageData.title);
                $("title").html(pageData.title);
                $(".top-bar-title").html(pageData.title);
                
                //banner
                $(".banner-content").css({
                    "background-image":"url(" + pageData.banner + ")",
                    "background-size": "contain",
                    "background-position": "left",
                    "background-repeat": "no-repeat"
                });
                for(var a=0;a<pageData.panels.length;a++){
                    $( "#" + pageData.panels[a].id).addClass(pageData.panels[a].data.class);
                    $( "#" + pageData.panels[a].id + ">div.panel-title>h2").html(pageData.panels[a].data.title);
                    console.log("setting hrefs");
                    $( "#" + pageData.panels[a].id + ">div.panel-text").html(pageData.panels[a].data.intro);
                    $( "#" + pageData.panels[a].id).attr("url",pageData.panels[a].data.link);
                    
                    
                }

                /*
                 * Attach the handlers once we have hte HREFs added:
                 */
                initLinkPanels();
            }

        },
        error:function(){
            console.log("failed to load content data");
        }
    });
}
        
function loadCommonElements(){
    $.ajax("/inc/footer.html",
    {
        success:function(data){
            $("#footer").html(data);
        },
        error:function(){
            console.log("failed to load footer");
        }
    });
}

function getPageFilename(){
    var filename = getCleanUrl().split(/\//)[getCleanUrl().split(/\//).length-1];
    if(filename.length === 0) filename = defaultPage;
    console.log("filename: "+filename);
    return filename;
}