//for ASPX, use: http://stackoverflow.com/questions/9035817/asp-net-c-sharp-get-all-text-from-a-file-in-the-web-path
// - basically, server.mapPath();
//and then list all files of type png/gif/jpg

var weddingfest07 = {
    
    
    test : function(){
        $.ajax("/proxy/listfiles.aspx",{
            dataType:"json"
        }).complete(function(data){
            console.log(data);
            var out = "";
            for(var a=0;a<data.responseJSON.images.length;a++){
                out += "<img width=\"300\" height=\"300\" class=\"imageflow\" src=\"" + data.responseJSON.images[a] + "\" longdesc=\"" + data.responseJSON.images[a] + "\" alt=\"image " + a + "\"/>";
            }

            console.log("APPENDING IMAGES:");
            $("#image-output").html(out);
            
            //assuming format is OK, call imageflow:
//            var x = new ImageFlow();
////            console.log(x);
//            x.init({ 
//                ImageFlowID:'image-output',
//                reflections: false,
//                reflectionP: 0.0
//            });
            
        }).error(function(err){
            console.log(err);
        });
        
    }
    
    
};





