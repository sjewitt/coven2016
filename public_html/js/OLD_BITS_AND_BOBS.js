//function getBandLinks(data){
//    var bandLinks = [];
//    var current;
//    for(var a=0;a<data.gigs.length;a++){
//        current = a;
//        var elem = document.createElement("span");
//        $(elem).html(data.gigs[a].band);
//        $(elem).attr("data-productid",a)
//        $(elem).click(function(){
//            getAmazonLinks(data,$(this).attr("data-productid"));
//        });
//        bandLinks.push($(elem));
//    }
//    return bandLinks;
//}

//function getAmazonLinks(data,index){
//    var x = $("#amazonlinks");
//    x.html(null);
//    for(var a=0;a<data.gigs[index].amazonProductIds.length;a++){
//        x.append(getAmazonLink(data.gigs[index].amazonProductIds[a]));
//    }
//}

//function getAmazonLink(productId){
//    var iframe = document.createElement("iframe");
//    iframe.setAttribute("class","amazonLink");
//    iframe.setAttribute("scrolling","no");
//    iframe.setAttribute("src",AMAZON_IFRAME_LINK_TEMPLATE.replace(/__PRODUCTID__/g,productId));
//    return iframe;
//}

//var URLMap = [
//    //{id:"home-banner",url:"#"},
//    {id:"home-panel-1",url:"#"},
//    {id:"home-panel-2",url:"#"},
//    {id:"home-panel-3",url:"#"},
//    {id:"home-panel-4",url:"#"}
//];




//function successHandler(ajaxdata){
//    data = ajaxdata;
//    $("#band").html(getBandLinks(data));
//}


    //do call to gcse as AJAX call
//    $.ajax({
//        "url":"js/data/gigs.json",
//        "success":successHandler
//    }); 

//IFrame link:
////<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="//ws-eu.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=GB&source=ac&ref=tf_til&ad_type=product_link&tracking_id=thecoven-21&marketplace=amazon&region=GB&asins=B00004UI4R&&show_border=true&link_opens_in_new_window=true"></iframe>
//var AMAZON_IFRAME_LINK_TEMPLATE = "//ws-eu.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=GB&source=ac&ref=tf_til&ad_type=product_link&tracking_id=thecoven-21&marketplace=amazon&region=GB&asins=__PRODUCTID__&&show_border=true&link_opens_in_new_window=true";
//
////plain image link:
////<a href="http://www.amazon.co.uk/gp/product/B00005LIWQ/ref=as_li_tl?ie=UTF8&camp=1634&creative=6738&creativeASIN=B00005LIWQ&linkCode=as2&tag=thecoven-21&linkId=TWPZUQS6EPIEGBVI"><img border="0" src="http://ws-eu.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=B00005LIWQ&Format=_SL110_&ID=AsinImage&MarketPlace=GB&ServiceVersion=20070822&WS=1&tag=thecoven-21" ></a><img src="http://ir-uk.amazon-adsystem.com/e/ir?t=thecoven-21&l=as2&o=2&a=B00005LIWQ" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
//var data;
