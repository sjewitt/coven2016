<%

//global current colour:
var currColour;

function getShaldonL1Nav(nodelist,color){
  //map topnav items to images:
  
  try{
    var out = '<table border="0" cellpadding="0" cellspacing="0" width="450">\n\t<tr>';    
    
    if(nodelist){  //nodelist may be false if the current page is at/near root
      for(var a=0;a<nodelist.length;a++){
        if(nodelist[a].isCurrentNode){
          out += '\t\t<td><a title="' + nodelist[a].getPage().linkText + '" href="ccms.asp?nodeid=' + nodelist[a].id + '"><img src="images/nav_buttons/' 
              + nodelist[a].getPage().name                //this is dependant on the image being present
              + '_' + color + '.jpg" border="0" alt="'    //this is dependant on correct color string being passed
              + nodelist[a].getPage().linkText + '" title="' + nodelist[a].getPage().linkText + '" height="20" /></a></td>\n';
        }
        else{
          out += '\t\t<td><a title="' + nodelist[a].getPage().linkText + '" href="ccms.asp?nodeid=' + nodelist[a].id + '"><img src="images/nav_buttons/' 
              + nodelist[a].getPage().name                //this is dependant on the image being present
              + '_white.jpg" border="0" alt="' + nodelist[a].getPage().linkText + '" title="' + nodelist[a].getPage().linkText + '" height="20" /></a></td>\n';
        }
      }
    }
    
    out += "\t</tr>\n</table>";
    return out;
  }
  catch(e){
    Response.Write("error in getShaldonL1Nav(): " + e.message);
    return "";
  }
}

function getShaldonL2Nav(nodelist){
  try{
    var out = '';
    if(nodelist){ //nodelist may be false if the current page is at/near root
      var page;
      for(var a=0;a<nodelist.length;a++){
        page = new Page(nodelist[a].pageId);
        
        if(nodelist[a].isCurrentNode){
          /*
          we only actually need to set the colour if we are at level 2 or below: (there was an 
          odd bug where isCurrentNode was set again when I passed the first node to the below helper function)
          */
          setSectionColour(nodelist[a]); 
          out += '<td class="hilite_' + currColour + '"><a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodelist[a].id + '" class="subnav">' + page.linkText + "</a></td>\n";
        }
        else{
          out += '<td><a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodelist[a].id + '" class="subnav">' + page.linkText + "</a></td>\n";
        }
      }
    }
    return out;
  }
  catch(e){
    Response.Write("error in getShaldonL2Nav(): " + e.message);
    return "";
  }
}

function getShaldonL3Nav(nodelist){
  try{
    var out = '';
    if(nodelist){ //nodelist may be false if the current page is at/near root
      var outArray = new Array();
      
      for(var a=0;a<nodelist.length;a++){
        page = new Page(nodelist[a].pageId);

        if(nodelist[a].isCurrentNode){
          outArray.push('\t<span>' + page.linkText + "</span>\n");
        }
        else{
          outArray.push('\t<a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodelist[a].id + '" class="l3_hilite_' + currColour + '">' + page.linkText + "</a>\n");
        }
      }
      out = outArray.join('<span class="l3_hilite_' + currColour + '"> | </span>')
    }
    return out;
  }
  catch(e){
    Response.Write("error in getShaldonL3Nav(): " + e.message);
    return "";
  }
}


//utility function to get current section colour:
function setSectionColour(node){
  try{
    var path = (new Navigation()).getBreadcrumb(node);

    var currSection = "";
    var currPage;
    
    for(var a=0;a<path.length;a++){
      if(path[a].level == 1){
        currSection = (new Page(path[a].pageId)).name;
      }
    }

    switch(currSection){
      case "about":
        currColour = "green";
      break;
      
      case "conservation":
        currColour = "green";
      break;
      
      case "visit":
        currColour = "blue";
      break;
      
      case "helpus":
        currColour = "blue";
      break;
      
      case "animals":
        currColour = "brown";
      break;
      
      case "gifts":
        currColour = "brown";
      break;
    }
  }
  catch(e){
    
  }  
}

/*
render the Animals main headings:
*/
function getShaldonL2AnimalsNav(currColour)
{
  try
  {
    currColour = "brown";
    var out = '';
    var page;
    for(var a=0;a<shaldonUtils.AnimalSection.length;a++){
      if(shaldonUtils.AnimalSection[a].id == parseInt(Request.QueryString("section"))){
        out += '<td class="hilite_' + currColour + '"><a title="' + shaldonUtils.AnimalSection[a].name + '" href="/ccms.asp?nodeid=' + Request.QueryString("nodeid") + '&amp;section=' + shaldonUtils.AnimalSection[a].id + '" class="subnav">' + shaldonUtils.AnimalSection[a].name + "</a></td>\n";
      }
      else{
        out += '<td><a title="' + shaldonUtils.AnimalSection[a].name + '" href="/ccms.asp?nodeid=' + Request.QueryString("nodeid") + '&amp;section=' + shaldonUtils.AnimalSection[a].id + '" class="subnav">' + shaldonUtils.AnimalSection[a].name + "</a></td>\n";
      }
      
           
    }
    //and render the edit link of logged in:
    var currentUser = userFactory.getCurrentUser();
    if(currentUser)
    {
      out += "<td><a title=\"Edit animals\" href=\"/shaldon_animals_edit.asp\">[Edit animals]</a></td>"
    }
     return out;
  }
  catch(e)
  {
       return(e.message);
  }
}  
function getShaldonL3AnimalsNav()
{
  try
  {
    var out = "";
    currColour = "brown"; 
    if(parseInt(Request.QueryString("section")) > 0)
    {
      var animalList = shaldonUtils.getAnimalsBySection(parseInt(Request.QueryString("section")));
      var outArray = new Array();
      for(var a=0;a<animalList.length;a++)
      {
        if(animalList[a].id == parseInt(Request.QueryString("animalid"))){
          outArray.push('\t<span>' + animalList[a].common_name + "</span>\n");
        }
        else{
          outArray.push('\t<a title="' + animalList[a].common_name + '" href="/ccms.asp?nodeid=' + Request.QueryString("nodeid") + '&amp;section=' + Request.QueryString("section") + '&amp;animalid=' + animalList[a].id + '" class="l3_hilite_' + currColour + '">' + animalList[a].common_name + "</a>\n");
        }  
      }

      out = outArray.join('<span class="l3_hilite_' + currColour + '"> | </span>');    
    }
    return(out);
  }
  catch(e)
  {
       return(e.message);
  }    
}


function getShaldonAnimal(animalId)
{
  try
  {
    var out = "";
    
    if(parseInt(animalId))
    {
    
      var animal = shaldonUtils.getAnimal(animalId);  
      //showObject(animal);
      
      out = "<table class=\"species\">";
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Common name</b></td>";
      out += "  <td class=\"species_cell_detail\">" + animal.common_name + "</td>";
      out += "</tr>";
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Specific name</b></td>";
      out += "  <td class=\"species_cell_detail\"><i>" + animal.specific_name + "</i></td>";
      out += "</tr>";
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Family</b></td>";
      out += "  <td class=\"species_cell_detail\">" + animal.family + "</td>";
      out += "</tr>";
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Behaviour</b></td>";
      out += "  <td class=\"species_cell_detail\">" + animal.behaviour + "</td>";
      out += "</tr>";
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Diet</b></td>";
      out += "  <td class=\"species_cell_detail\">" + animal.diet + "</td>";
      out += "</tr>";
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Habitat</b></td>";
      out += "  <td class=\"species_cell_detail\">" + animal.habitat + "</td>";
      out += "</tr>";
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Status</b></td>";
      out += "  <td class=\"species_cell_detail\">" + animal.status + "</td>";
      out += "</tr>";
      
      if(animal.threats != "")
      {
        out += "<tr>";
        out += "  <td class=\"species_cell_title\"><b>Threats</b></td>";
        out += "  <td class=\"species_cell_detail\">" + animal.threats + "</td>";
        out += "</tr>";
      }
      
      out += "<tr>";
      out += "  <td class=\"species_cell_title\"><b>Location</b></td>";
      out += "  <td class=\"species_cell_detail\">" + animal.location + "</td>";
      out += "</tr>";
      out += "</table>";

    }
    else
    {
      //hard-coded IDs for intro pages
      //get the intro object:
      
      var textToShow = 1; //LOCAL
      //var textToShow = 17;  //SHALDON
      switch(parseInt(Request.QueryString("section")))
      {
       
        //LOCAL
        case 1: //mammals
           textToShow = 2;
        break;
        
        case 2: //birds
           textToShow = 4;
        break;
        
        case 3: //reptiles
            textToShow = 3;
        break;
       /*
      //SHALDON
        case 1: //mammals
           textToShow = 18;
        break;
        
        case 2: //birds
           textToShow = 19;
        break;
        
        case 3: //reptiles
            textToShow = 20;
        break;
        */
      
        
        default:
          
        
      }
      out = (new Content(textToShow)).getActiveInstance().getContent();
    }
    
    return(out);
  }
  catch(e)
  {   
  return("error in getShaldonAnimal(): Supplied ID: " + animalId + ", error: "+e.message);    
  }
}

function getShaldonAnimalImage(animalId)
{
  try
  {
    var out = "";
    if(parseInt(animalId))
    {
      var animal = shaldonUtils.getAnimal(animalId);
      out = "<img src=\"" + animal.main_image + "\" alt=\"" + animal.common_name + "\" />";
    }
    return(out);
  }
  catch(e)
  {       
  }
}


%>
