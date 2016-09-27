function popup(url,width,height){
  //alert("popping up: " + width +", "+height);
  var win = window.open(url,'popup','width=' + width + ',height=' + height + ',toolbar=0,resizable=1,scrollbars=1');
  win.resizeTo(width,height);
  win.focus();
}
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
      if(confirm("You are about to " + action + " this User. Proceed?")){
        document.user.submit();
      }
    }
    else{
      alert("All user property fields must be filled.");
    }
  }
  function deleteCT(){
    if(confirm("You are about to delete this Content Type. Proceed?")){
      document.deletect.submit();
    }
  }
  function doCTAction(action){
    if(document.contenttype.name.value.toString() != ""){
      if(confirm("You are about to " + action + " this Content Type. Proceed?")){
        document.contenttype.submit();
      }
    }
    else{
      alert("The 'name' field cannot be empty.");
    }
  }
  function reloadOpener(newloc){
    window.opener.location = newloc;
  }
var elemList = [
  {tab:'tab1',panel:'panel1'},
  {tab:'tab2',panel:'panel2'},
  {tab:'tab3',panel:'panel3'},
  {tab:'tab4',panel:'panel4'}
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
function setAction(action){
  document.forms["vt"].action.value = action;
}
function checkVTForm(frm){
  alert(frm.action.value);
  return false;
}
function doAction(nodeId){
   alert("test: "+nodeId);
   /*
   try{
    alert(document.viewtreeactions.getaction.options[document.viewtreeactions.getaction.selectedIndex].value);

 
  //split to get the action and the nodeId:
  var data = document.viewtreeactions.getaction.options[document.viewtreeactions.getaction.selectedIndex].value.split("_");
  var nodeId = data[1];
  var action = data[0];
  var alertStr = "";
  
  switch(action){
  
    case "reorder":
      alertStr = "Re-order child pages of node" + nodeId;
    break;
    
    case "layout":
      alertStr = "modify layouts";
    break;
    
    case "pageprops":
      alertStr = "modify properties of the page";
    break;
    
    case "nodeprops":
      alertStr = "modify properties of the node" + nodeId;
    break;
    
    default:
      alertStr = "Please select an action to proceed.";
    break;
  
  }
  
  //alert("node = " + nodeId + "\naction = " + action);
  alert(alertStr);
   
  }
  catch(e){
    alert(e.message);
  }
   */
}