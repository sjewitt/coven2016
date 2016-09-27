<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<!--#include virtual="/ccms_asp/editor/shaldonUtils.asp"-->
<!--#include virtual="/ccms_asp/engine/shaldon/ShaldonAnimal.asp"-->
<%
//load specific one if ID is passed
var currentAnimal = new ShaldonAnimal();
var currAnimalId = "";  //for form field

if(parseInt(Request.QueryString("current_animal")) && parseInt(Request.QueryString("current_animal")) > 0)
{
  currentAnimal = shaldonUtils.getAnimal(parseInt(Request.QueryString("current_animal")));
  currAnimalId = currentAnimal.id; 
}

function getSectionDropdown(currentAnimal)
{
  var AnimalSection = new Array();
  AnimalSection.push({id:1,name:"Mammals"});
  AnimalSection.push({id:2,name:"Birds"});
  AnimalSection.push({id:3,name:"Reptiles"});

  var out = "";

  for(var a=0;a<AnimalSection.length;a++)
  {
    out += "<option value=" + AnimalSection[a].id;
    if(currentAnimal.section == AnimalSection[a].id)
    {
      out += " selected=\"selected\"";
    }
    out += ">"+ AnimalSection[a].name + "</option>\n";
  }
  return out;
}

if((new String(Request.Form("action")) == "add") || (new String(Request.Form("action")) == "update"))
{
  //initialise animal object:
  currentAnimal.section        = new String(Request.Form("section"));
	currentAnimal.common_name    = new String(Request.Form("common_name"));
	currentAnimal.specific_name  = new String(Request.Form("specific_name"))
	currentAnimal.family         = new String(Request.Form("family"))
	currentAnimal.behaviour      = new String(Request.Form("behaviour"))
	currentAnimal.diet           = new String(Request.Form("diet"))
	currentAnimal.habitat        = new String(Request.Form("habitat"))
	currentAnimal.status         = new String(Request.Form("status"))
	currentAnimal.location       = new String(Request.Form("location"))
	
  if(new String(Request.Form("action")) == "update")
  {
    currentAnimal.id           = parseInt(Request.Form("id"));
    currentAnimal.section      = new String(Request.Form("section"));
    shaldonUtils.updateAnimal(currentAnimal);
    Response.Redirect(Request.ServerVariables("SCRIPT_NAME")+"?current_animal=" + currentAnimal.id);
  }
  if(new String(Request.Form("action")) == "add")
  {
    shaldonUtils.addAnimal(currentAnimal);
  }  
}

//evaluate user session:
var currentUser = userFactory.getCurrentUser();
if(currentUser){


%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <style>
  
  </style>
  <script type="text/javascript" src="/script/dom.js"></script>
  
  <!-- TinyMCE main .js path -->
  <script type="text/javascript" src="/ccms_asp/editor/tiny_mce/tiny_mce.js"></script>
  <!-- and initialise TinyMCE to use ANY textarea (there is only one...) -->
  <script type="text/javascript">
  
  tinyMCE.init(
    {
      mode : "textareas",
      theme : "simple", 
      //theme : "advanced",
      //theme_advanced_toolbar_location : "top",
      //theme_advanced_toolbar_align : "left",
      //theme_advanced_statusbar_location : "bottom",
      //theme_advanced_resizing : true
      //external_image_list_url : "/ccms_asp/editor/imagelist_JSON.asp",
      //external_link_list_url : "/ccms_asp/editor/linklist_JSON.asp"
    }
  );
  </script>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <script type="text/javascript" language="javascript">
  function submitForm(action)
  {
    try
    {
      alert(action);
      document.animal.action.value = action;
      document.animal.submit();
    }
  catch(e)
  {
    showObject(e);
  }    
}

function setValues(val)
{
  try
  {
    document.forms.animals.submit();
  }
  catch(e)
  {
  
  }
}
  </script>
    
  <title>Manage Animals</title>
  </head>
  
  <body>
    XX
    XX
    <div id="container">
      <div id="editor_content">
        <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/layouts100x130.jpg" alt="Create page" />
          <h1>Manage Animals</h1>
        </div>

        
        <table> 
          <tr>
            <form name="animals" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?nodeid=<%=Request.QueryString("nodeid")%>" method="get">
               <td>Current animals</td>
               <td><%=shaldonUtils.getExistingAnimals(shaldonUtils.getAnimalsList(),currentAnimal)%></td>
            </form>
          </tr>     
       
      
      <form name="animal" id="animal" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
        <input type="hidden" name="id" value="<%=currAnimalId%>" />
        <input type="hidden" name="action" value="add" />
          <tr>
            <td>Section</td>
            <td>
              <select name="section">
                <%=getSectionDropdown(currentAnimal)%>
              </select>
            </td>
          </tr>
          <tr>
            <td>Common Name</td>
            <td><input type="text" name="common_name" value="<%=currentAnimal.common_name%>" /></td>
          </tr>
          <tr>
            <td>Specific Name</td>
            <td><i><input type="text" name="specific_name" value="<%=currentAnimal.specific_name%>" /></i></td>
          </tr>
          <tr>
            <td>Family</td>
            <td><input type="text" name="family" value="<%=currentAnimal.family%>" /></td>
          </tr>
          <tr>
            <td>Behaviour</td>
            <td><textarea name="behaviour"><%=currentAnimal.behaviour%></textarea></td>
          </tr>
          <tr>
            <td>Diet</td>
            <td><textarea name="diet"><%=currentAnimal.diet%></textarea></td>
          </tr>
          <tr>
            <td>Habitat</td>
            <td><textarea name="habitat"><%=currentAnimal.habitat%></textarea></td>
          </tr>
          <tr>
            <td>Status</td>
            <td><input type="text" name="status" value="<%=currentAnimal.status%>" /></td>
          </tr>
          <tr>
            <td>Location</td>
            <td><input type="text" name="location" value="<%=currentAnimal.location%>" /></td>
          </tr>
          <tr>
            <td colspan="2">
              <%if(currentAnimal.id > 0){%>
              <input type="button" name="submitbtn" value="Update" onclick="submitForm('update');" />
              <%}else{%>
              <input type="submit" name="submitbtn" value="Add" onclick="submitForm('add');" />
              <%}%>
            </td>
          </tr>
        </table>
      </form>
              <p>
        [<a href="#" onclick="javascript:history.go(-1);return false;">back</a>]
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
      </div>
    </div>
  </body>
</html>
<%
}
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN.<br />PLEASE CLOSE THIS WINDOW AND LOG IN AGAIN.");
}
%>



