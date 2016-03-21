var SiteController = {
    switchControl : function(JQObj){
        
        //deselect all:
        $("input.valueStatic").each(function(){
            $(this)[0].checked = false;
            $(this).parent().css({"color":"black","background":"white"});
        });

        $(JQObj).parent().css({"color":"white","background":"black"});
        $(JQObj).prop("checked","checked");
    }
};

$(function(){
    
    $("input.valueStatic")[0].checked = true;
    $("input.valueStatic").first().parent().css({"color":"white","background":"black"});
    
    //attach click handlers to checkboxes:
    $("input.valueStatic").each(function(){
        $(this).click(function(){
            SiteController.switchControl($(this));  //the outer div
        });
    });
});
