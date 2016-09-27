/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var SiteController = {
    
    switchControl : function(JQObj){	
        console.log(JQObj);
        var controlChk = document.getElementById('public_control');
        var consumeChk = document.getElementById('public_consume');

        var controlChkDiv = document.getElementById('public_control_id');
        var consumeChkDiv = document.getElementById('public_consume_id');

        if (controlChk.checked)
        {
            // ensure public consumer checkbox is unchecked
            consumeChk.checked = false;

            // #PF UX1: change colours
            consumeChkDiv.style.color = "black";
            consumeChkDiv.style.background = "white";

            controlChkDiv.style.color = "white";
            controlChkDiv.style.background = "black";
        }
    }
    
}

//use JQuery Ready function as starting point: 
$(function(){
    
    //attach click handlers to checkboxes:
    $("input.valueStatic").each(function(){
        $(this).click(function(){
            //alert("clicked " + $(this).attr("id"));
            SiteController.switchControl($(this));  //the outer div
        });
    });
    
});
