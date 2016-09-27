//for AJAX working:
//http://stackoverflow.com/questions/4901537/how-to-show-processing-animation-spinner-during-ajax-request

/*
 * TODO:
 * Push author/book/track onto breadcrumb, and attach appropriate handlers for browsing back.
 * Also - add ability to grab author/book/track with URL params?
 * @type type
 */
var librivox = {
    
    //strings:
    text_welcome : "Start by entering an author name in the form.",
    
    //proxyUrl : "/proxy/proxy.aspx",
    proxyUrl : "/proxy/proxy.aspx",
    searchPanelIdentifier :         "#body-content > div.pure-u-1.pure-u-sm-1-4.contentpanel.row > div.panel-text",
    outputPanelIdentifier :         "#body-content > div.pure-u-1.pure-u-sm-3-4.contentpanel.row > div.panel-text",
    displayPanelTitleIdentifier :   "#body-content > div.pure-u-1.pure-u-sm-3-4.contentpanel.row > div.panel-title > h2",
    
    outputPanelTitle : "",
    previousContent : "",
    firstLoadMessage : "Loading LibriVox data...",
    
    currentBookDetails : {},
    
    /*
     * TODO: 
     * Build stack for main panel display (fro breadcrumb) and for the nav panel:
     * may need to modify this...
    */
    outputPanelStack : {
        VIEW_INITIAL : {    //after initiial ajax load
            findState:null,
            displayState:null
        },
        VIEW_BY_AUTHOR : {  //view of books by selected author
            findState:null,
            displayState:null
        },
        VIEW_BY_BOOK : {    //view tracks after selecting a book
            findState:null,
            displayState:null
        },
        VIEW_BY_TRACK : {    //view after selecting a track (the html 5 player)
            findState:null,
            displayState:null
        }
    },
    
    init : function(){
        this.BuildLibrivoxForm();
    },
    
    /*
     * elements built here will have handlers attached as well to trigger the librivox calls
     * @returns {undefined}
     */
    BuildLibrivoxForm : function(){

        //Append autocomplete
        var wrapper = document.createElement("div");
        var elem = document.createElement("input");
        elem.setAttribute("id","autocomplete-data");
        var elem2 = document.createElement("input");    //set hidden
        elem2.setAttribute("id","autocomplete-data-id");
        elem2.setAttribute("type","hidden");
        var elem3 = document.createElement("input");    //set hidden
        elem3.setAttribute("id","autocomplete-data-surname");
        elem3.setAttribute("type","hidden");
        var elem4 = document.createElement("input");    //set hidden
        elem4.setAttribute("id","autocomplete-data-forename");
        elem4.setAttribute("type","hidden");
        
        var clear = getCloseButton("author-search-clear");
        $(clear).css({"cursor":"pointer"}).click(function(){
            $("#autocomplete-data")[0].value = "";
            $(librivox.outputPanelIdentifier).empty();
            librivox.updateDisplayPanelTitle("LibriVox");
        });
        
        $(wrapper).append($(elem));
        $(wrapper).append($(clear));
        $(wrapper).append($(elem2));
        $(wrapper).append($(elem3));
        $(wrapper).append($(elem4));
        
        $(this.searchPanelIdentifier).append($(wrapper));
        
        $.ajax(this.proxyUrl + "?endpoint=api/feed/authors",{
            dataType:"json"
        }).complete(function(data){  
            var autocompleteData = [];
            for(var a=0;a<data.responseJSON.authors.length;a++){
                autocompleteData.push({label : data.responseJSON.authors[a].last_name + ", " + data.responseJSON.authors[a].first_name, value : data.responseJSON.authors[a].id, surname : data.responseJSON.authors[a].last_name, forename:data.responseJSON.authors[a].first_name});
            }
            librivox.updateDisplayPanelTitle("LibriVox");
            $("#autocomplete-data").autocomplete({
                source: autocompleteData,
                select: function( event, ui ) {
                    $( "#autocomplete-data" ).val( ui.item.label );
                    $( "#autocomplete-data-id" ).val( ui.item.value );  //hide this. we need surname for book search
                    $( "#autocomplete-data-surname" ).val( ui.item.surname ); 
                    $( "#autocomplete-data-forename" ).val( ui.item.forename ); 
 
                    //and trigger the next AJAX call to get the books by selected author:
                    librivox.buildLibrivoxBooklistByAuthor({
                        surname: $( "#autocomplete-data-surname" ).val(),
                        authorId : $( "#autocomplete-data-id" ).val()
                    });
 
                    return false;
                 }
            });
        });
    },
    
    
    
    BuildLibrivoxResponse : function(params){
        //params is an object...
        //
        //push dynamic search form on to LH panel:

        //add params here:
        //Turn into a function that responds to the form/list?
        //Add bits that dynamically update the form as well (author/book lists etc.)
        $.ajax(this.proxyUrl + "?" + params,{
            dataType:"json"
        }).complete(function(data){  
                $("#body-content > div.pure-u-1.pure-u-sm-3-4.contentpanel.row > div.panel-text").html(data.responseText);
        });
    },
    
    buildLibrivoxBooklistByAuthor : function(params){
        //TODO: Filter by language if supplied
        var out = [];
        $.ajax(this.proxyUrl + "?endpoint=api/feed/audiobooks&author=" + params.surname,{
            dataType:"json"
        }).complete(function(data){
            for(var a=0;a<data.responseJSON.books.length;a++){
                if(checkAuthor(params.authorId,data.responseJSON.books[a])){
                    //include this book
                    out.push(data.responseJSON.books[a]);
                }
            }
            
            //process output
            $(librivox.outputPanelIdentifier).html(getBooklistOutput(out));
            $(librivox.updateDisplayPanelTitle("books by " + $("#autocomplete-data-forename").val() + " " + $("#autocomplete-data-surname").val()));

        }).error(function(err){
            console.log(err);
        });
    },
    
    loadBookDetails : function(bookId){
        $.ajax(this.proxyUrl + "?endpoint=api/feed/audiobooks&id=" + bookId,{
            dataType:"json"
        }).complete(function(data){
            //there should only be one book for supplied ID:
            
            $(librivox.outputPanelIdentifier).html(getBookDetailsOutput(data.responseJSON.books[0]).content);
            $(librivox.outputPanelIdentifier).append(getBookDetailsOutput(data.responseJSON.books[0]).close);
            //process link to downloads here
        }).error(function(err){
            console.log(err);
        });
    },
    
    /*
     * build track player - this will just be a HTML5 audio tag with perhaps a back/next to 
     * navigate the tracks for current book.
     * @returns {undefined}
     */
    loadTrackPlayer : function(sections,currentSection){

        //get current contents of display area:
        
        
        //https://developer.mozilla.org/en/docs/Web/HTML/Element/audio
        var audio = document.createElement("audio");
        audio.setAttribute("controls","controls");
        
        //start disabled:
        audio.setAttribute("autoplay","autoplay");
        
        var source = document.createElement("source");
        source.setAttribute("src",$(currentSection).attr("data-file"));
        audio.appendChild(source);
        $(librivox.outputPanelIdentifier).html(audio);
        
    },
    
    //may need to change this:
    getAudioLinkOutput : function(bookObj){
        var out = document.createElement("div");

        /*
         * For the RSS mp3 links, create a HTML5 overlay player.
         * Ensure the correct MIME type?
         */
        var dataType = "xml";
        var ajaxUrl = this.proxyUrl + "?endpoint=rss/" + bookObj.id;

        $.ajax(ajaxUrl,{
            dataType:dataType
        }).complete(function(data){

            var items = data.responseXML.getElementsByTagName("item");
            librivox.currentBookDetails = items;
/*
 *  <item>
 *      <title><![CDATA[track title]]></title>
 *      <reader></reader>
 *      <link><![CDATA[http://www.archive.org/download/[trackname].mp3]]></link>
 *      <enclosure url="http://www.archive.org/download/[trackname].mp3" length="15.7" type="audio/mpeg"/>
 *      <itunes:explicit xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">No</itunes:explicit>
 *      <itunes:block xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">No</itunes:block>
 *      <itunes:duration xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"><![CDATA[hh:mm:ss]]></itunes:duration>
 *      <pubDate></pubDate>
 *      <media:content xmlns:media="http://search.yahoo.com/mrss/" url="http://www.archive.org/download/[filename].mp3" fileSize="15.7" type="audio/mpeg"/>
 *  </item>
 */
            for(var a=0;a<items.length;a++){
                var row = document.createElement("div");
                var childs = items[a].childNodes;
                var link = "";
                var title = "";
                var duration = "";
                for(var b=0;b<childs.length;b++){
                    switch(childs[b].nodeName){
                        case "link":
                            link = childs[b].firstChild.nodeValue; //check for node type?
                        break;
                        case "title":
                            title = childs[b].firstChild.nodeValue; //check for node type?
                        break;
                        case "itunes:duration":
                            duration = childs[b].firstChild.nodeValue; //check for node type?
                        break;
                    }
                }

                row.setAttribute("data-file",link);
                row.setAttribute("data-time",duration);
                row.setAttribute("data-index",a);
                
                $(row).css("cursor","pointer");
                row.appendChild(document.createTextNode(title));
                
                $(row).hover(
                    function(){$(this).css("text-decoration","underline");},
                    function(){$(this).css("text-decoration","none");}
                );

            
                $(row).click(function(data){
                    //alert("audio file=" + $(this).attr("data-file"));
                    librivox.loadTrackPlayer(librivox.currentBookDetails, $(this));
                    //trigger overlay with audio tag + next/back track buttons:
                    //TODO!
                });
                //and append the click handler TODO:
                out.appendChild(row);
            }
           
        }).error(function(err){
            console.log(err);
        });
        return out;
    },
 
    updateDisplayPanelTitle : function(val){
        $(this.displayPanelTitleIdentifier).html(val);
    },
    
    updateDisplayPanelText : function(val){
        $(this.outputPanelIdentifier).html(val);
    }

};

//utility functions:
function checkAuthor(authorId, bookObj){
    var val = false;
    
    for(var a = 0;a < bookObj.authors.length; a++){
        if(bookObj.authors[a].id === authorId){
            val = true;
        }
    }

    return val;
}

//output format functions:
function getBooklistOutput(booklistObj){
    var out2 = document.createElement("div");
    //$(out2).css({"height":"250px","overflow":"auto"});
    $("#output-panel").css({"height":"initial"});
    $("#list-panel").css({"height":"initial"});
    for(var a=0;a<booklistObj.length;a++){
        var out = document.createElement("div");
        out.setAttribute("bookid",booklistObj[a].id);
        var txt = document.createTextNode(booklistObj[a ].title);
        out.appendChild(txt);
        
        $(out).hover(
                    function(){$(this).css("text-decoration","underline");},
                    function(){$(this).css("text-decoration","none");}
                );
        
        //attach handler to each book title row:
        $(out).click(function(){
            //store current contents of output panel in cache:
            librivox.previousContent = $(librivox.outputPanelIdentifier+">div").clone(true);
            
            //load book details:
            librivox.loadBookDetails($(this).attr("bookid"));
        }).css({"cursor":"pointer"});
        out2.appendChild(out);
    }
    return(out2);
}

function getBookDetailsOutput(bookObj){
    var out = "";
    if(bookObj !== undefined){  //in case there are none. perhaps check for length higher up?
        out = document.createElement("div");
        //$(out).css({"height":"240px","overflow":"auto"});
        var close = getCloseButton("book-details-close");

        //apply action to this instance
        $(close).click(function(){
            $(librivox.outputPanelIdentifier).empty();
            $(librivox.outputPanelIdentifier).append($(librivox.previousContent));
            librivox.updateDisplayPanelTitle("books by " + $("#autocomplete-data-forename").val() + " " + $("#autocomplete-data-surname").val());
        }).css({"cursor":"pointer"});
        
        var description = document.createElement("div");
        description.innerHTML = bookObj.description;
        //description.innerHTML += "project ID: " + bookObj.id;
        
        //append listen/download display:
        //TODO!
        //out.innerHTML = librivox.getAudioLinkOutput(bookObj);
        
        out.appendChild(description);
        
        out.appendChild(librivox.getAudioLinkOutput(bookObj));
        
        librivox.updateDisplayPanelTitle(bookObj.title);
    }
    return {"content":out,"close":close};
}

//unescape stuff:
//http://stackoverflow.com/questions/1147359/how-to-decode-html-entities-using-jquery
function decodeEntities(encodedString) {
    var textArea = document.createElement('textarea');
    textArea.innerHTML = encodedString;
    return textArea.value;
}
function getCloseButton(DOMId){
    var close = document.createElement("img");
    $(close).attr("src","/images/css/purple-close.png");
    $(close).css({"width":"20px","height":"20px"});
    $(close).attr({"id":DOMId});
    return(close);
}
//from http://jsfiddle.net/RwE9s/15/
function StringtoXML(text){
    if (window.ActiveXObject){
        var doc = new ActiveXObject('Microsoft.XMLDOM');
        doc.async = 'false';
        doc.loadXML(text);
    } 
    else {
        var parser=new DOMParser();
        var doc=parser.parseFromString(text,'text/xml');
    }
    return doc;
}
