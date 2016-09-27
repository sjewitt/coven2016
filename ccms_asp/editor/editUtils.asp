<%
var editUtils = new Object();

editUtils.treeListHTML = "";

//generic function to build and return a HTML LIST defining the viewtree
editUtils.buildTree = function(node){
  	try{
    	editUtils.treeListHTML = "";
    	buildTree(node);
      return "<ul>" + editUtils.treeListHTML + "</ul>"
      }
    catch(e){
      showObject(e);
      return false;
    }
  }
  
function buildTree(node){
  	try{
    	var page = new Page(node.pageId);
    	editUtils.treeListHTML += "\n\t<li id=\"node_" + node.id + "\" title=\"" + page.linkText + "\">\n";

    	if(node.childArray.length>0){
        editUtils.treeListHTML += "\t\t<!-- childs --><ul>\n";
        for(var a=0;a<node.childArray.length;a++){
      		buildTree(node.childArray[a]);
    	  }
    	  editUtils.treeListHTML += "\n\t\t</ul><!-- end childs -->\n";
        
    	}
    	editUtils.treeListHTML += "\t</li>\n" 
    }
    catch(e){
      showObject(e);
    }
  }



editUtils.addContentMapping = function(pageId,slotId,contentId){
  try{
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var updateSQL = "insert into page_content_ref(content_id,page_id,slot_num) values (" + contentId + ", " + pageId + ", " + slotId + " );";
    connection.execute(updateSQL);
    connection.close(); 
    connection = null;
    return true;
  }
  catch(e){
    //Response.Write(log error:
    recordset = null;
    connection = null;
    return false;
  }
}

editUtils.removeContentMapping = function(pageId,slotId,contentId){
  try{
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var updateSQL = "delete from page_content_ref where page_id=" + pageId + " and slot_num=" + slotId + ";";
    connection.execute(updateSQL);
    connection.close(); 
    connection = null;
    return true;
  }
  catch(e){
    //Response.Write(e.message);
    recordset = null;
    connection = null;
    return false;
  }
}

editUtils.updateContentMapping = function(pageId,slotId,contentId){
  try{
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var updateSQL = "update page_content_ref set content_id=" + contentId + "where page_id=" + pageId + " and slot_num=" + slotId;
    connection.execute(updateSQL);
    connection.close(); 
    connection = null;
    return true;
  }
  catch(e){
    //log error:
    recordset = null;
    connection = null;
    return false;
  }
}

//create a new page and return the new ID: [TRANSACTION here]
editUtils.createNewPage = function(user,name,title,linktext,description,keywords){
  try{
    var returnval = false;
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    //begin transaction
    var sql = "insert into page (state,name,linktext,title,description,keywords,created_date,created_user) values ";
    sql += "(" + State.ACTIVE + ", '"+name+"', '"+linktext+"', '"+title+"', '"+description+"', '"+keywords+"',GETDATE()," + user.id + ");";
    connection.execute(sql);
    //if(connection.ErrorCode() == 7){
      var recordset   = Server.CreateObject("ADODB.Recordset");
      sql = "select max(id) as newpageid from page;";
      recordset = connection.execute(sql);
      returnval = parseInt(recordset("newpageid"));
      recordset.close();
      recordset = null;
    //}
    //end transaction 
    connection.close(); 
    connection = null;
    return returnval
  }
  catch(e){
    //rollback transaction
    Response.Write("error in editutils.createNewPage(): " + e.message);
    recordset = null;
    connection = null;
    return false;
  }
}

//return a list of HREFs for all pages. Used by 'managepages':
//perhaps abstract this to a generic function?
editUtils.getNodeLinks = function(nodeArray){
  try{
    var out = new Array();
    for(var a=0;a<nodeArray.length;a++){
      //TODO: GET PATH HERE.
      out.push('<a href="#" onclick="reloadOpener(\'/ccms.asp?nodeid=' + nodeArray[a].id + '\');">' + (new Page(nodeArray[a].pageId)).linkText + '</a>');
    }
    return out.join(", ");
  }
  catch(e){
    Response.Write("error in editutils.getNodeLinks(): " + e.message);
  }
}

//TODO: Move to Node():
editUtils.updateLayoutMap = function(node,layout){
  try{
    var out         = new Array();  //of Content instances
    var connection  = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    //var recordset   = Server.CreateObject("ADODB.Recordset");
    
    var sql         = "update viewtree set layout_id=" + layout.id + " where id=" + node.id + ";";
    connection.execute(sql);
    connection.close();
    connection = null;
    return true;
  }
  catch(e){
    Response.Write("error in editUtils.updateLayoutMap(): " + e.message)
    connection = null;
    return false;
  }
}

//CARE with this - only call if certain the node has no children.
editUtils.removeViewtreeNode = function(node){
  try{
    if(node.hasChildren){
      
      return false;
    }
    else{
      var connection  = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      //var recordset   = Server.CreateObject("ADODB.Recordset");
      
      var sql         = "delete from viewtree where id=" + node.id + ";";
      connection.execute(sql);
      connection.close();
      connection = null;
      return true;
    }
  }
  catch(e){
    Response.Write("error in editUtils.removeViewtreeNode(): " + e.message)
    connection = null;
    return false;
  }
}

editUtils.deleteInstance = function(contentInstance){
  try{
    //showObject(contentInstance)  
    
    //Response.Write("deleting content " + contentInstance.contentId + ", version " + contentInstance.id + "<br>");
    
    var connection  = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var recordset   = Server.CreateObject("ADODB.Recordset"); 
     
    //ensure there is > 1 instance:
    var countSql = "select count (*) as count from content_version where content_id=" + contentInstance.contentId + ";";  
     
    recordset = connection.execute(countSql);
    if(parseInt(recordset("count")) > 1){
      //Response.Write("> 1 instance: OK to delete");
      var sql         = "delete from content_version where id=" + contentInstance.id + ";";
      //Response.Write(sql);
      connection.execute(sql);
      connection.close();
      connection = null;
      return true;     
    }
    else{
      throw new Error("Cannot delete instance. There is already only one.");
      return false;
    }
  }
  catch(e){
    Response.Write("error in editUtils.deleteInstance(): " + e.message);
    return false;  
  }
}


//retrieve all content as an array: (perhaps filter by subtype?)  this needs to go to a 'contentManager utility?'
editUtils.getContentItems = function(){
  try{
    var out         = new Array();  //of Content instances
    var connection  = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var recordset   = Server.CreateObject("ADODB.Recordset");
    
    var sql         = "select id from content order by name;";
    recordset       = connection.execute(sql);
    
    while(!recordset.EOF){
      out.push(new Content( parseInt(recordset("id")) ));
      recordset.MoveNext();
    }
    
    recordset.close();
    recordset = null;
    connection.close();
    connection = null;
    return out;
  }
  catch(e){
    recordset = null;
    connection = null;
    return null;
  }
}

//just return the inline javascript to reload the opener:
//apply this to all popups upon completion of the action.
editUtils.getOpenerReloadJavascript = function(){
  var out = "<script type=\"text/javascript\">\n";
  //out += "if(window.opener.location);\n";
  out += "window.opener.location.reload(true);\n";
  //out += ";\n";
  out += "</script>\n";
  return(out);
}

//just return the inline javascript to reload the opener:
//apply this to all popups upon completion of the action.
editUtils.getOpenerParentReloadJavascript = function(node){
  var out = "<script type=\"text/javascript\">\n";
  out += "window.opener.location.href = '/ccms.asp?nodeid=" + node.id + "';\n";
  //out += "window.opener.location.go(true);\n";
  out += "</script>\n";
  return(out);
}

//retrieve an HTML OPTIONS list based on the permissions of teh current user:
editUtils.getInstanceActionOptions = function(userObject,instanceList){
  try{
    var out = "";
    if((userObject.permissions & Permissions.CHANGESTATE) || (userObject.permissions & Permissions.ADMINISTRATOR)){
      out += "\t<option value='" + State.ACTIVE + "'>Set Active</option>\n";
      out += "\t<option value='" + State.REJECTED + "'>Set Rejected</option>\n";
    }
    //sort out?
    if((userObject.permissions & Permissions.EDITCONTENT) || (userObject.permissions & Permissions.ADMINISTRATOR)){
      out += "\t<option value='" + State.ATWORK + "'>Set At Work</option>\n";
      out += "\t<option value='" + State.PENDING + "'>Set For Approval</option>\n";
    }
    
    //Only offer the delete options if correct perms AND there is > 1 instance:
    if(instanceList.length > 1 && ((userObject.permissions & Permissions.DELETECONTENT) || (userObject.permissions & Permissions.ADMINISTRATOR))){
      out += "\t<option value='delete'>Delete instance</option>\n";
    }
    return(out);
  }
  catch(e){
    //error trap
    return("");
    
  }
}

/*
//just a string: The javascript to handle the various edit popups
editUtils.getActionsJavascript = function(){
  try{
    var out = "<script type=\"text/javascript\">\n"
                    + "function popup(url,width,height){\n"
                    //+ "\talert(width +', '+height);\n"
                    //+ "\tvar width=400;var height=300;\n"
                    //+ "\tswitch(size){\n"
                    //+ "\t\tcase 'small':\n"
                    //+ "\t\t\twidth=460; height=300;\n"
                    //+ "\t\tbreak;\n"
                    //+ "\t\tcase 'medium':\n"
                    //+ "\t\t\twidth=460;height=450;\n"
                    //+ "\t\tbreak;\n"
                    //+ "\t\tcase 'large':\n"
                    //+ "\t\t\twidth=840;height=680;\n"
                    //+ "\t\tbreak;\n"
                    //+ "\t}\n"
                    + "\tvar win = window.open(url,'popup','width=' + width + ',height=' + height + ',toolbar=0,resizable=1,scrollbars=1');\n"
                    + "\twin.resizeTo(width,height);\n"
                    + "\twin.focus();\n"
                    + "}\n"
                    + "</script>\n";
    return out;
  }
  catch(e){
    return("");
  }
}
*/

editUtils.getContentTypeOptions = function(typeId){
  try{
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var updateSQL = "select id,name from content_types;";
    var recordset   = Server.CreateObject("ADODB.Recordset");
    recordset = connection.execute(updateSQL);
    var out = "";
    var selected = "";
    while(!recordset.EOF){
      selected = "";
      if(typeId == recordset("id")){
        selected = " selected=\"selected\"";
      }
      out += '\t<option value="' + recordset("id") + '"' + selected + '>' + recordset("name") + '</option>\n';
      recordset.MoveNext();
    }
    recordset.close();
    recordset = null;
    connection.close(); 
    connection = null;
    return(out);
  }
  catch(e){
    recordset = null;
    connection = null;
    return(false);
  }
}

editUtils.getPageEditOptions = function(currentUser,refCount){
  try{
    //TODO: Sort out rights - abstract to ROLES?
    var out = '<select style="width:160px;" name="action">\n';
    out += '\t<option value=""> - select - </option>\n'
    //add page to viewtree,delete page (state=INACTIVE?)
    if(refCount == 0){
      out += '\t<option value="add">Add page reference to viewtree</option>\n';
      out += '\t<option value="delete">Delete page</option>\n';
    }
    //add ANOTHER viewtree ref, manage viewtree
    if(refCount > 0){
      out += '\t<option value="add">Add another page reference to viewtree</option>\n';
      out += '\t<option value="managevt">Manage viewtree</option>\n';
    }
    out += '\t<option value="properties">Properties</option>\n';
    out += '</select>\n';
    out += '<input type="button" value="OK" onclick="doAction(document.updatelayout);" />\n'
    return out;
  }
  catch(e){
    //log error:
    return "";
  }
}

//handle slot-editing options:
editUtils.getEditJavascript = function(slotId){
  try{
    //JS handler:
    var out = "";
    out += "<script type=\"text/javascript\">\n";
    out += "function doedit" + slotId + "(form){\n";
    out += "\tvar slotId = form.slotnum.value;\n";
    out += "\tvar contentId = form.contentid.value;\n";
    out += "\tvar pageId = form.pageid.value;\n";
    out += "\tvar action = form.action[form.action.selectedIndex].value;\n";
    //TODO: This popup needs to be a js function in a .js file
    //trigger the edit content window:
    out += "\tif(action == 'edit')popup('/ccms_asp/editor/editcontent.asp?contentid=' + contentId,820,670);\n"
    
    //trigger the content properties window:
    out += "\tif(action == 'props')popup('/ccms_asp/editor/contentprops.asp?contentid=' + contentId,400,420);\n"
    
    //trigger the replace content window:
    out += "\tif(action == 'replace')popup('/ccms_asp/editor/assigncontent.asp?slotid=' + slotId + '&pageid=' + pageId + '&doaction=replace'," + SIZE_ASSIGN_CONTENT + ");\n";
    
    //trigger the create content window:
    out += "\tif(action == 'create') popup('/ccms_asp/editor/createcontent.asp?slotid=' + slotId + '&pageid=' + pageId,400,420);\n";
    
    //trigger the clear slot method call:
    out += "\tif(action == 'remove') popup('/ccms_asp/editor/removecontent.asp?slotid=' + slotId + '&pageid=' + pageId + '&doaction=remove',400,420);\n"
    
   //trigger the clear slot method call:
    out += "\tif(action == 'add') {popup('/ccms_asp/editor/assigncontent.asp?slotid=' + slotId + '&pageid=' + pageId + '&doaction=add'," + SIZE_ASSIGN_CONTENT + ");\n}"
    
    //07.11.09: trigger edit content properties box:
    out += "\tif(action == 'contentproperties')popup('/ccms_asp/editor/editcontentproperties.asp?contentid=' + contentId,400,460);\n"
    
    out += "}\n";
    out += "</script>\n";
    return(out);
  }
  catch(e){
    return("");
  }
}

editUtils.replaceEditBanner = function(inStr,currentUser,page){
  try{
    var outStr = inStr;
    var editBannerStr = "";
    
    //Response.Write("CURRENT USER: "+currentUser)
    
    if(currentUser && currentUser.permissions){
      var nodeid  = 0;
      var param = "?";
      if(Request.QueryString("nodeid") && (new String(Request.QueryString("nodeid"))) != "undefined"){
        nodeid = new String(Request.QueryString("nodeid"));
        param = "?nodeid=" + nodeid + "&";
      }
      editBannerStr = "<link rel=\"stylesheet\" type=\"text/css\" href=\"/ccms_asp/editor/styles/editstyles.css\" />\n";
      editBannerStr += EDITOR_JAVASCRIPTS;
      editBannerStr += "<div id=\"editbanner\">\n";
      
      //generate javascript handlers:
      //editBannerStr += this.getActionsJavascript(page);
      editBannerStr += "<p id=\"userdisplay\">"+currentUser.fullName+"  [<a href=\"" + Request.ServerVariables("SCRIPT_NAME") + param + "logout=true\">logout</a>]</p>";
      
      //add options here depending on permissions:

      var editOptions = new Array();
      var url = "";
      if(currentUser.permissions & Permissions.ADMINISTRATOR){
        url = "/ccms_asp/admin/admin.asp";
        editOptions.push("\t<span class=\"editoption\"><a title=\"User management, permissions management, content subtype management. \" href=\"#\" onclick=\"popup('" + url + "',"  + SIZE_ADMIN_HOME + ")\">ADMIN</a></span>\n");
      }
      if(currentUser.permissions & Permissions.ADMINISTRATOR || currentUser.permissions & Permissions.UPLOADBINARY){
        url = "/ccms_asp/editor/uploadbinary.asp";
        editOptions.push("\t<span class=\"editoption\"><a title=\"Upload images and cocuments.\" href=\"#\" onclick=\"popup('" + url + "',"                                           + SIZE_UPLOAD_BINARY + ")\">Add binaries</a></span>\n");
      }
      if(currentUser.permissions & Permissions.CREATEPAGE || currentUser.permissions & Permissions.ADMINISTRATOR){  //only allow this if has Permissions.EDITVIEWTREE?
        url = "/ccms_asp/editor/createpage.asp";
        editOptions.push("\t<span class=\"editoption\"><a title=\"Create a new page and optionally assign it to a viewtree position\" href=\"#\" onclick=\"popup('" + url + "',"      + SIZE_CREATE_PAGE + ")\">Create Page</a></span>\n");
      }
      if(currentUser.permissions & Permissions.EDITVIEWTREE || currentUser.permissions & Permissions.ADMINISTRATOR){  //only allow this if has Permissions.EDITVIEWTREE?
        url = "/ccms_asp/editor/managepages.asp";
        editOptions.push("\t<span class=\"editoption\"><a title=\"Lists all pages and offers options to remove, edit, add to viewtree.\" href=\"#\" onclick=\"popup('" + url + "',"   + SIZE_MANAGE_PAGES + ")\">Manage Pages</a></span>\n");
      }
      //if(currentUser.permissions & Permissions.EDITVIEWTREE || currentUser.permissions & Permissions.ADMINISTRATOR){  //only allow this if has Permissions.EDITVIEWTREE?
      //  url = "/ccms_asp/editor/assignlayouts.asp?nodeid=" + nodeid;
      //  editOptions.push("\t<span class=\"editoption\"><a title=\"Assign layout to viewtree.\" href=\"#\" onclick=\"popup('" + url + "',"                                             + SIZE_ASSIGN_LAYOUT + ")\">Assign Layouts</a></span>\n");
      //}
      
      if(currentUser.permissions & Permissions.EDITPAGE || currentUser.permissions & Permissions.ADMINISTRATOR){  //only allow this if has Permissions.EDITVIEWTREE?
        url = "/ccms_asp/editor/managenavigation.asp?nodeid=" + nodeid;
        editOptions.push("\t<span class=\"editoption\"><a title=\"Manage ordering of pages etc.\" href=\"#\" onclick=\"popup('" + url + "',"                                             + SIZE_ASSIGN_LAYOUT + ")\">Manage Navigation</a></span>\n");
        //opens siblingorder.asp
      }
      
      if(currentUser.permissions & Permissions.CREATECONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){
        url = "/ccms_asp/editor/createcontent.asp";
        editOptions.push("\t<span class=\"editoption\"><a title=\"Create content.\" href=\"#\" onclick=\"popup('" + url + "',"                                                        + SIZE_CREATE_CONTENT + ")\">Create content</a></span>\n");
      }
      //MANAGE EXISTING CONTENT:
      if(currentUser.permissions & Permissions.EDITCONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){
        url = "/ccms_asp/editor/managecontent.asp";
        editOptions.push("\t<span class=\"editoption\"><a title=\"Manage content.\" href=\"#\" onclick=\"popup('" + url + "',"                                                        + SIZE_MANAGE_CONTENT + ")\">Manage content</a></span>\n");
      }
      
      if(currentUser.permissions & Permissions.EDITPAGE || currentUser.permissions & Permissions.ADMINISTRATOR){
        url = "/ccms_asp/editor/pageproperties.asp?pageid=" + page.id;
        editOptions.push("\t<span class=\"editoption\"><a title=\"Edit the core properties of a page.\" href=\"#\" onclick=\"popup('" + url + "',"                                    + SIZE_PROPS_PAGE + ")\">Edit Page Properties</a></span>\n");
      }
      if(currentUser.permissions & Permissions.DELETEPAGE || currentUser.permissions & Permissions.ADMINISTRATOR){
        url = "/ccms_asp/editor/removeviewtreebranch.asp?nodeid=" + nodeid;
        editOptions.push("\t<span class=\"editoption\"><a title=\"Remove current page from viewtree.\" href=\"#\" onclick=\"popup('" + url + "',"                                     + SIZE_REMOVE_PAGE + ")\">Remove page</a></span>\n"); //make not visible? Hmmm...
        //NOTE: This is quite a complex SQL - it needs to recurse down to all childs as well! - ie walk the viewtree from HERE and generate SQL for each 
        //entry. A TRANSACTION should then occur - perhaps flagging as inactive?
      }
      editBannerStr += editOptions.join(" | ");
      editBannerStr += "</div>\n"
    }
    return(outStr.replace("{CMS_EDITLINKS}",editBannerStr));
  }
  catch(e){
    Response.Write(e.message);
  }
}

//returns an OBJECT, with slotId and the string: 
editUtils.getSlot = function(slot,contentMap){
  try{
    var editSlotObject      = new Object();  //abstract!!!
    var slotNum             = parseInt(slot.split("{CMS_CONTENT_")[1].split("}")[0]);
    editSlotObject.slotId   = slotNum;
    
    var pageId              = contentMap.pageId;
    var contentId           = 0;
    
    //map the slot to the content:
    for(var a=0; a<contentMap.mapping.length; a++){
      if(contentMap.mapping[a].slotId == slotNum){
        contentId = contentMap.mapping[a].contentId;
      }
    }
    
    var out = "\n\n<!-- BEGIN EDIT CODE FOR SLOT " + slotNum + " \nSLOT " + slotNum + ", CONTENT " + contentId + "\n-->";
    out += this.getEditJavascript(slotNum);
    if(contentId == 0){
      out += "[no content]";
    }
    
    out += "<form name=\"editslot" + slotNum + "\" action=\"\" class=\"editdropdown\">\n";
    out += "<input type=\"hidden\" name=\"slotnum\" value=\"" + slotNum + "\" />";
    out += "<input type=\"hidden\" name=\"contentid\" value=\"" + contentId + "\" />";
    out += "<input type=\"hidden\" name=\"pageid\" value=\"" + pageId + "\" />";
    out += "<select name=\"action\">\n";
    out += "<option> - Choose Action: - </option>\n";
    
    /*
    BIG TODO: 
    Sort out permission patterns here:
    */
    //if there is content offer options to edit, replace or remove:
    if(contentId > 0){
      if(currentUser.permissions & Permissions.EDITCONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){
        out += "<option value=\"edit\">Edit current content</option>\n";
        //TODO:
        //out += "<option value=\"props\">Edit content properties</option>\n";
      }
      if(currentUser.permissions & Permissions.EDITPAGE || currentUser.permissions & Permissions.ADMINISTRATOR){ 
        out += "<option value=\"remove\">Remove content</option>\n";
        out += "<option value=\"replace\">Replace content</option>\n";
      }
      
      //07.11.09: trigger content properties editor:
      if(currentUser.permissions & Permissions.CREATECONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){ 
        out += "<option value=\"contentproperties\">Properties</option>\n";
      }
    }
    
    //otherwise offer options to create or add existing
    else{
      if(currentUser.permissions & Permissions.CREATECONTENT || currentUser.permissions & Permissions.ADMINISTRATOR)out += "<option value=\"create\">Create new content</option>\n";
      if(currentUser.permissions & Permissions.EDITPAGE || currentUser.permissions & Permissions.ADMINISTRATOR)out += "<option value=\"add\">Add existing content</option>\n";
    }
    
    out += "</select>\n";
    out += "<input type=\"button\" value=\"ok\" onclick=\"doedit" + slotNum + "(document.forms.editslot" + slotNum + ");\" />\n"
    out += "</form>\n";
    out += "<!-- END EDIT CODE FOR SLOT " + slotNum + " -->\n\n";
    
    editSlotObject.content = out;
    return(editSlotObject);
  }
  catch(e){
    Response.Write("ERROR IN GETSLOT(): "+e.message);
    return(null);
  }
}

/*
methods to populate the TinyMCE linklist and imagelist:
*/

//get array of filenames/option texts. returns an array of these: ["linkText", "ccms?nodeid=nnn"]
editUtils.getInternalLinkArray = function(asJSON){
  try{
  
    var treeNodes = (new Viewtree()).getAllNodes();
    var data        = new Array();
    var currPage = new Page();
    var currLinkText = "";
    
    //for later versions of tinyMCE:
    if(asJSON){
        for(var a=0;a<treeNodes.length;a++){
            currPage = new Page(treeNodes[a].pageId);
            if(currPage.linkText){
                currLinkText = currPage.linkText;  
            }
            else{
                currLinkText = "[node=" + treeNodes[a].id + "]" ;
            }
            data.push('{title : "' + currLinkText + '",value : "/ccms.asp?nodeid=' + treeNodes[a].id + '"}\n');
        }
    }
    else{   //for OLD version of tinyMCE
        for(var a=0;a<treeNodes.length;a++){
            currPage = new Page(treeNodes[a].pageId);
                if(currPage.linkText){
                    currLinkText = currPage.linkText;  
                }
                else{
                    currLinkText = "[node=" + treeNodes[a].id + "]" ;
                }
            data.push("\n['" + currLinkText + "','/ccms.asp?nodeid=" + treeNodes[a].id + "']");
        }
    }
    return data;
  }
  catch(e){
    
  }
}

//get array of filenames/option texts. returns an array of these: ["imagename", "imageurl"]
//param: boolean getImages: true: returns images, false returns configured binary types
editUtils.getUploadedBinaryLinkArray = function(getImages,asJSON){
    try{
        if(getImages == undefined){
            getImages = false;  
        }
    
        var imagePath   = UPLOADFILEPATH;
        var realpath    = Server.MapPath("/" + UPLOADFILEPATH + "/");
        var filesystem  = Server.CreateObject("Scripting.FileSystemObject");
        var folder      = filesystem.GetFolder(realpath);
        var files       = folder.Files;
        var enumerator  = new Enumerator(files);         //MS ScriptingHost object
        var data        = new Array();
    
        //enumerate:
        enumerator.moveFirst();
        var currFile;
        var currExtension;
        while(!enumerator.atEnd()){
            currFile = enumerator.item();
            currExtension = currFile.Name.substring(currFile.Name.lastIndexOf(".")+1,currFile.Name.length);
      
            if(asJSON){ //for V4 tinyMCE
                //get images = true, configured image types, NOT download object type:
                if(getImages && IMAGETYPES[currExtension.toUpperCase()] &! (INSERTABLEDOWNLOADTYPES[currExtension.toUpperCase()])){
                    //data.push('"{title : \"XXX\",value : \"YYY\"}"');   //TODO
                    data.push('{title : "' + currFile.Name.substring(0,currFile.Name.lastIndexOf(".")) + '",value : "/' + UPLOADFILEPATH + '/' + currFile.Name + '"}');
                }

                //if we are not getting images and the filetype is in the configured list:
                else if(!getImages && this.isDownloadableType(currExtension)){
                    //check here for configured MIME types:
                    data.push('{title : "[' + currExtension + '] ' + currFile.Name.substring(0,currFile.Name.lastIndexOf(".")) + '",value : "/' + UPLOADFILEPATH + '/' + currFile.Name + '"}\n');
                }
            }
            else{   //older tinyMCE
                //get images = true, configured image types, NOT download object type:
                if(getImages && IMAGETYPES[currExtension.toUpperCase()] &! (INSERTABLEDOWNLOADTYPES[currExtension.toUpperCase()])){
                    data.push('\n["' + currFile.Name.substring(0,currFile.Name.lastIndexOf(".")) + '","/' + UPLOADFILEPATH + '/' + currFile.Name + '"]');
                }

                //if we are not getting images and the filetype is in the configured list:
                else if(!getImages && this.isDownloadableType(currExtension)){
                    //check here for configured MIME types:
                    data.push('\n["[' + currExtension + '] ' + currFile.Name.substring(0,currFile.Name.lastIndexOf(".")) + '","/' + UPLOADFILEPATH + '/' + currFile.Name + '"]');
                }
            }
            enumerator.moveNext();  
        }
        
        
        return(data);
    }
    catch(e){
        Response.Write("error in editUtils.getUploadedBinaryLinkArray(): "+e.message);
    }
}

/*
determine if the extension is in the permitted configurable download types:
*/
editUtils.isDownloadableType = function(extension){
  try{
    if((!IMAGETYPES[extension.toUpperCase()]) && INSERTABLEDOWNLOADTYPES[extension.toUpperCase()]){
      return true;
    }
    else{
      return false;
    }
  }
  catch(e){
    return false;  
  }  
}

%>
