<%
function getShaldonTopNav(node,color){
  //map topnav items to images:
  var out = '<table border="0" cellpadding="0" cellspacing="0" width="450">\n\t<tr>';
  try{
    if(node.hasChildren){
      var childs = node.getChildren();
      
      for(var a=0;a<childs.length;a++){
        if(childs[a].id != parseInt(Request.QueryString("nodeid"))){
          out += '\t\t<td><a title="' 
              + childs[a].getPage().linkText 
              + '" href=ccms.asp?nodeid=' 
              + childs[a].id 
              + '><img src="images/nav_buttons/' 
              + childs[a].getPage().linkText      //this is dependant on the image being present
              + '_white.jpg" border="0" alt="' 
              + childs[a].getPage().linkText 
              + '" title="' 
              + childs[a].getPage().linkText 
              + '" height="20" /></a></td>\n';
        }
        /*
        write the current tab:
        TODO: This needs to be a LINK if L2 is PARENT.
        */
        else{
          out += '\t\t<td><a title="' 
              + childs[a].getPage().linkText 
              + '" href=ccms.asp?nodeid=' 
              + childs[a].id 
              + '><img src="images/nav_buttons/' 
              + childs[a].getPage().linkText            //this is dependant on the image being present
              + '_' + color + '.jpg" border="0" alt="'  ////this is dependant on correct color string being passed
              + childs[a].getPage().linkText 
              + '" title="' 
              + childs[a].getPage().linkText 
              + '" height="20" /></a></td>\n';
        }
      }
    }
    out += "\t</tr>\n</table>";
    return out;
  }
  catch(e){
    Response.Write("error in getShaldonTopNav(): " + e.message);
    return out;
  }
}
%>
