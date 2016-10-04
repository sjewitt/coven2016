/*
GLOBAL EDITOR JAVASCRIPTS:
*/
$(function(){
    
    //handle submission of text editor form:
    $("input#save-content").click(function(){
        document.forms.updatecontent.submit();
    });
    
    //file upload change dialogue:
    $("#file_upload_selector").change(function(){
        if($(this).val()){
            $("#file_upload_submit").prop("disabled",false);
        }
    });
    
    /*
     * manage page create form:
     */
    $("#create_page_form input").each(function(){       //apply the handlers
        
        $(this).change(function(){
            var _linktext = false;
            var _name = false;
            var _title = false;
            $("#create_page_form input").each(function(){//check each for values
                switch($(this).attr("name")){
                    case "name":
                        if($(this).val().length > 0){_name = true;}
                        break;
                        
                    case "title":
                        if($(this).val().length > 0){_title = true;}
                        break;
                        
                    case "linktext":
                        if($(this).val().length > 0){_linktext = true;}
                        break;
                }
                if(_name && _linktext && _title){
                    $("#create_page_submit").prop("disabled",false);
                }
                else{
                    $("#create_page_submit").prop("disabled",true);
                }
            });
        });
    });
    
    /*
     * Apply DataTables to any content list:
     */
    $("#list-content").DataTable();
    
    //load the editor for edit page:
    try{
        tinyMCE.init({
            selector:"textarea#text-editor",
            height: 430,
            width:700,
            plugins: [
                'advlist autolink lists link image charmap print preview anchor',
                'searchreplace visualblocks code fullscreen',
                'insertdatetime media table contextmenu paste code'
            ],
            toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
            content_css: [
                '//fast.fonts.net/cssapi/e6dc9b99-64fe-4292-ad98-6974f93cd2a2.css',
                '//www.tinymce.com/css/codepen.min.css'
            ],
            image_list : "/ccms_asp/editor/imagelistJSON.asp",
            link_list : "/ccms_asp/editor/linklistJSON.asp"    
        });
    }
    catch(e){};

    //initialize calendar widget on create content page:
//    if(calendar && calendar !== undefined){
//        calendar.set("validfrom");
//        calendar.set("validto");
//    }
    
    //manage enablement of create button:
    $("input#new_content_name").keyup(function(){
        var _name = false;
        if($(this).val().length > 0){_name = true;}
        else{_name = false;}

        if(_name){ $("#content_create_submit").prop("disabled",false);}
        else{      $("#content_create_submit").prop("disabled",true);}
    });
    

    
    
    
    
    
});

/*
 * Aug 2016 - 
 * Properly wrap up the functions into an object
 * 
 * 
 */
var editScripts = {
    popup  : function(url){
        var width = 980;
        var height = 720;
        var win = window.open(url,'popup','width=' + width + ',height=' + height + ',toolbar=0,resizable=1,scrollbars=1');
        win.resizeTo(width,height);
        win.focus();
    },
    
    validateFields : function(){
        var ok = true;
        var fields = ['login','password','fullname','email'];
        for(var a=0;a<fields.length;a++){
            if(document.user[fields[a]].value == ""){
                ok = false;
            }
        }
        return ok;
    },
    
    layoutAction : function(action){
        try{
            action = parseInt(action);
            var layout = document.layoutaction.layout[document.layoutaction.layout.selectedIndex].value;
            var msg = "";
            document.layoutaction.doaction.value = action;
            switch(action){
                case 1:
                    msg = "Edit source HTML (edit code in HTML form, update file)";
                break;
                case 2:
                    msg = "Set visibility to editor (set new DB flag, modify code accordingly)";
                break;
                case 3:
                    msg = "Delete this template (delete file)";
                break;
                case 4:
                    msg = "Add a new template (create file from POSTed source)";
                break;
                default:
            }
            
            document.layoutaction.submit();
        }
        catch(e)
        {
          alert(e.message);
        }
    }
};


//function popup(url,width,height){
function popup(url){
  //alert("popping up: " + width +", "+height);
  var width = 980;
  var height = 720;
  var win = window.open(url,'popup','width=' + width + ',height=' + height + ',toolbar=0,resizable=1,scrollbars=1');
  win.resizeTo(width,height);
  win.focus();
}

/*
ADMIN JAVASCRIPTS
*/
//USERS:
function validateFields(){
  var ok = true;
  var fields = ['login','password','fullname','email'];
  for(var a=0;a<fields.length;a++){
    if(document.user[fields[a]].value == ""){
      ok = false;
    }
  }
  return ok;  
}

function setPerms(){
  var chkbxArray = document.user.permission;
  var perms = 0;
  for(var a=0;a<chkbxArray.length;a++){
    if(chkbxArray[a].checked){
      perms = perms + parseInt(chkbxArray[a].value);
    }
  }
  document.user.permissions.value=perms;
}

function doUserAction(action){
  if(validateFields()){
    //if(confirm("You are about to " + action + " this User. Proceed?")){
      document.user.submit();
    //}
  }
  else{
    alert("All user property fields must be filled.");
  }
}

//CONTENT TYPES:
function deleteCT(){
  //if(confirm("You are about to delete this Content Type. Proceed?")){
    document.deletect.submit();
  //}
}
  
function doCTAction(action){
  if(document.contenttype.name.value.toString() != ""){
    //if(confirm("You are about to " + action + " this Content Type. Proceed?")){
      document.contenttype.submit();
    //}
  }
  else{
    alert("The 'name' field cannot be empty.");
  }
}

/*
FOR 'managepages':
*/
//Open the selected viewtree ref in the parent window: 
function reloadOpener(newloc){
  window.opener.location = newloc;
}

/*
define tab/panel div ID mapping.
This also defines other proprties such as 
iteation length to capture the URL tab index
parameter.
[note - functions with dynamic ASP replacements are inline]
*/

/*
General tab manipulation functions:
*/

var elemList = [
  {tab:'tab1',panel:'panel1'},
  {tab:'tab2',panel:'panel2'},
  {tab:'tab3',panel:'panel3'},
  {tab:'tab4',panel:'panel4'}
  /*{tab:'tab5',panel:'panel5'}*/
  ];

function showPanel(panelId){
  var panel;
  var tab;
  for(var a=0;a<elemList.length;a++){
    panel   = document.getElementById(elemList[a].panel);
    tab     = document.getElementById(elemList[a].tab);
    panel.style.display       = "none";
    tab.style.color           = "#eee";
    tab.style.backgroundColor = "#ccc";
    if(elemList[a].panel == panelId){
      panel.style.display = "block";
      tab.style.color = "purple";
      tab.style.backgroundColor = "#999";
    }
    var out = "";
    var count = 0;
    for(p in panel.style){
      out += (p+"="+panel.style[p]+"\t");
      if(count>=10){
        count=0;
        out+="\n";
      }
    }
  }
}

//tab 1:
function setAction(action){
  document.forms["vt"].action.value = action;
  //and submit it...
}
function checkVTForm(frm){
  alert(frm.action.value);
  return false;
}


//from manageviewtree - jump to appropriate page:
function doAction(nodeId){
   try{
    //alert(nodeId);
    //retrieve the action from the selected item. The node ID is passed in as an argument:
    var action = document.viewtreeactions.getaction.options[document.viewtreeactions.getaction.selectedIndex].value;
    var alertStr = "";
  
  
    switch(action){
  
      case "reorder":
        alertStr = "Re-order child pages of viewtree node " + nodeId;
        //if(confirm(alertStr)){
          window.location = "/ccms_asp/editor/siblingorder.asp?nodeid=" + nodeId;  
        //}
      break;
    
      case "layout":
        alertStr = "Manage layouts";
        //if(confirm(alertStr)){
          window.location = "/ccms_asp/editor/assignlayouts.asp?nodeid=" + nodeId;
        //}
      break;
    
      case "pageprops":
        alertStr = "Manage properties of the page that is referenced by this viewtree node";
        //if(confirm(alertStr)){
          window.location = "/ccms_asp/editor/pageproperties.asp?nodeid=" + nodeId;  
        //}
      break;
    
      //info only
      case "nodeprops":
        alertStr = "Properties of this viewtree node (" + nodeId + "):\n\tReferring page: \n\t";
        alert(alertStr);
      break;
    
      case "movenode":
        alertStr = "Move this node (" + nodeId + ") to a new viewtree location";
        //if(confirm(alertStr)){
          window.location = "/ccms_asp/editor/movenode.asp?nodeid=" + nodeId;   
        //}
      break;
    
      default:
        alertStr = "Please select an action to proceed.";
        alert(alertStr);
      break;
    }
  }
  catch(e){
    alert(e.message);
  }
}

function submitMoveNode(){
  try{
    //if(confirm("Move selected viewtree item to this location?")){
      document.movenode.submit();
    //}
  }  
  catch(e){
    alert(e.message);
  }
}

/*
submit template actions:
*/
//function layoutAction(action)
//{
//  try
//  {
//    action = parseInt(action);
//    var layout = document.layoutaction.layout[document.layoutaction.layout.selectedIndex].value;
//    var msg = "";
//    document.layoutaction.doaction.value=action;
//    switch(action)
//    {
//      case 1:
//        msg = "Edit source HTML (edit code in HTML form, update file)";
//      break;
//      case 2:
//        msg = "Set visibility to editor (set new DB flag, modify code accordingly)";
//      break;
//      case 3:
//        msg = "Delete this template (delete file)";
//      break;
//      case 4:
//        msg = "Add a new template (create file from POSTed source)";
//      break;
//      default:
//    }
//    //alert(action + ", " + layout);
//    //if(confirm(msg))
//    //{
//      document.layoutaction.submit();
//      window.resizeTo(600,500);
//    //}
//  }
//  catch(e)
//  {
//    alert(e.message);
//  }
//}