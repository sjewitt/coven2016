<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//TODO: Do this as a .ASP page, I can then dynamically set the options.
Response.AddHeader("content-type","text/javascript");
var currentUser = userFactory.getCurrentUser();
if(currentUser){

%>

/*
TODO: Modify this to accept an array of handler functions. That way, I can
use this same function to manage the other tree-based editor pages:
*/


  		
/*
TODO: Can I recurse down the tree from this point and set everything also BOLD/GRREN?
    also, can I DISABLE the click handers?

     -> Yes - I know what the incoming node ID is, so simplky get that node as it 
     is unique and then simply reset all to be - eg - grey and disabled.
     I need to do server-side checking as well... 

*/

//window.onload = function(){
function buildTree(nodeToMove){
	
	//alert(nodeToMove);
  
  var handlers = new Handlers();

	//retrieve all the UL tags inside the nav container:
	var lists   = document.getElementById("tree").getElementsByTagName("ul");

	//handle sibling insertion:
	var arr = new Array();

	/*
	HANDLE THE UL PARENT ELEMENT:
	I need to insert a click handler as a SIBLING ABOVE the UL tag:
	*/
	var elem;
	var index;

	//append an onclick handler
	var b;
	var c;
	for(var a = 1; a < lists.length; a++){
		//close by default:
		lists[a].style.display = "none";

		elem              = document.createElement('span');
		elem.onclick      = handlers.click_opener;
		elem.onmouseover  = handlers.mouseover_pointer;
		elem.innerHTML    = "&nbsp;+&nbsp;";
		addElementAsFirstItem(lists[a].parentNode,elem);
	}

	//and unhide the root:
	lists[0].style.display = "block";

	/*
	HANDLE THE LI ITEM ELEMENTS:
	get all the LI tags to generate the click event for dropdown insertion:
	Note: I need to do it this way because if I try to add onclick to the LI, it conflicts with the opener.
	*/

	var items   = document.getElementById("tree").getElementsByTagName("li");

	var text;

	for(a = 0; a < items.length; a++){

		//create a SPAN to insert in the current LI tag:
		elem = document.createElement("span");

		//we need the ID:
		elem.setAttribute("id","span_" + items[a].getAttribute("id"));

		//create a text node to insert into the new SPAN. Use the LI attribute 'title' as dynamically obtained:
		text = document.createTextNode(items[a].getAttribute("title") + " (" + items[a].getAttribute("id") + ")");
		elem.appendChild(text);

		//attach a click handler:
		elem.onclick = handlers.click_settarget;

		//attach an onhover handler:
		elem.onmouseover = handlers.mouseover_pointer;

		addElementAsFirstItem(items[a],elem);
	}
	
	//and disable everything below nodeToMove:
	var disabledBranchRoot = document.getElementById(nodeToMove);//this is the LI tag
	disabledBranchRoot.firstChild.onclick=handlers.click_void;
	disabledBranchRoot.style.color = "grey"; //because the outer LI encloses all the child ones, this style cascades.

  var disabledBranchOther = disabledBranchRoot.getElementsByTagName("li");
	//alert(disabledBranchRoot.id)
	for(a=0;a<disabledBranchOther.length;a++){
    //and disable the click handler
    disabledBranchOther[a].firstChild.onclick=handlers.click_void;
  }
}

/*
Class holding event handlers. 'this' refers to the element to which
the handler has been assigned.
*/
function Handlers(){
  try{
  	/*
  	generic onmouseover pointer handler
  	*/
  	Handlers.prototype.mouseover_pointer = function(){
  		this.style.cursor = "pointer";
  	}
  	
  	/*
  	handle opening/closing of child item list:
  	*/
  	Handlers.prototype.click_opener = function(){
  	
  		if(this.innerHTML == "&nbsp;+&nbsp;") this.innerHTML = "&nbsp;-&nbsp;";
  		else this.innerHTML = "&nbsp;+&nbsp;"
  
  		var obj     = this.parentNode;     //I need to get the parent LI tag and then get the nested UL - there should be only one....
  		var childContainer = obj.getElementsByTagName("ul")[0]; //there's only one...
  		if(childContainer.style.display == "block") childContainer.style.display = "none";
  		else childContainer.style.display = "block";
  	}
  	
  	Handlers.prototype.click_void = function(){
      var msg = "This is the branch you are about to move.\nYou cannot move the node to itself or childs of itself.\nThat would be confusing...";
      alert(msg);
      return false;
    }
  	
  	/*
  	handle setting the new parent ID:
  	*/
  	Handlers.prototype.click_settarget = function(){
      
        	
  	  var currSpan;
  	 	var currParent;
 
      //get the SPAN elements, set all to font weight normal:
  		var currSpans = document.getElementById("tree").getElementsByTagName("span");

      //iterate over these and remove any that are id="actionbtn" and reset the font colours:
      var x = "";
  		for(var a=0;a<currSpans.length;a++){
        if(currSpans[a].getAttribute("id") == "actionbtn"){
          currParent = currSpans[a].parentNode;
          currParent.removeChild(currSpans[a]);  
        }
  		  currSpans[a].style.fontWeight = "normal";
  		  currSpans[a].style.color = "black";
      }  		
      
      //and reset the nde/branch being moved to grey:
      var disabledBranchRoot = document.getElementById(nodeToMove);//this is the LI tag
	    //disabledBranchRoot.firstChild.onclick=handlers.click_void;
	    disabledBranchRoot.style.color = "grey"; //because the outer LI encloses all the child ones, this style cascades.
      disabledBranchRoot.firstChild.style.color = "grey";
      var disabledBranchOther = disabledBranchRoot.getElementsByTagName("li");
    	//alert(disabledBranchRoot.id)
    	for(a=0;a<disabledBranchOther.length;a++){
        //and disable the click handler
        disabledBranchOther[a].firstChild.style.color = "grey";
      }
      
  		//and set the current one to BOLD:
  		this.style.fontWeight = "bold";
  		this.style.color = "green";
  		
  		//create wrapper to contain the button:
      var selSpan = document.createElement("span");
      selSpan.setAttribute("id","actionbtn");
      
      var btn = document.createElement("input");
      btn.setAttribute("type","button");
      btn.setAttribute("name","doaction");
      btn.setAttribute("value","move here");
      
      var nodeId = this.getAttribute("id").split("_")[2];
      
      btn.onclick = function(){submitMoveNode()};
      //moveNode
      
  		selSpan.appendChild(btn);
  		
      this.appendChild(selSpan);

  		//set the hidden PARENT field to this ID
  		var formElement = document.getElementById("targetid");
  		formElement.value = nodeId;  //field value is constructed like so: span_node_nn
  	}
  }
  catch(e){
    alert(e.message);
  }
}

/*
add a new DOM element as the first child of PARENT:
  */
function addElementAsFirstItem(parent,itemToAdd){
	try{
		arr = new Array();  //reset temp array.
		var nodeList      = parent.childNodes;

		//add the click span to the top of the
		var arr = new Array();
		for(b=0;b<nodeList.length;b++){
			arr.push(nodeList[b]);
		}

		arr.reverse();

		//add new element to array, and reverse so it is at the top:
		arr.push(itemToAdd);
		arr.reverse();

		//add each element on the array to the current item:
		for(c=0;c<arr.length;c++){
			parent.appendChild(arr[c]);
		}
	}
	catch(e){
		alert(e.message);
	}
} 
/*
add DOM element at specified position

function addDropdown(parent,itemToAdd){
	try{
		var initialList 	= parent.childNodes;
		var modifiedList    = new Array();

		var insertAt = 1;

		//if there's only one, there are no childs:
		if(initialList.length == 1) insertAt = 0;

		for(var a=0;a<initialList.length;a++){
			modifiedList.push(initialList[a]);
			if(a == insertAt) modifiedList.push(itemToAdd);
		}
		
		//append the modified list:
		for(a=0;a<modifiedList.length;a++){
            parent.appendChild(modifiedList[a]);
		}
	}
	catch(e){
		alert(e.message)
	}
}
*/


<%
} 

%>