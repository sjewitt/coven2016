<%
/*
Class abstracting a Message object.

This is basically the same as a viewtree node - us the same abstracted logic
for recursion

*/

function Message(id){
  this.id           = 0;
  this.threadId     = 0;
  this.parentId     = 0;
  this.title        = null;
  this.body         = null;
  this.date         = new Date();
  this.createdUser  = 0;
  
  //constructor:
  if(id){
    try{
      this.id = id;
      //load message from DB
      //...
    }
    catch(e){
    }
  }
  
  
  
  //if a new one has been created, save it back to the database:
  Message.prototype.save = function(){
    try{
      
    }
    catch(e){
      
    }
  }
  
  //load the message from the database
  Message.prototype.load = function(){
    try{
      if(this.id > 0){
      
      }
      else{
        throw new Error("No message ID. Cannot load.");
      }
    }
    catch(e){
      
    }
  }
  
  //return the parent Message object:
  Message.prototype.getParent = function(){
    
  }
  
  //return an array of the direct children of this Message:
  Message.prototype.getChildren = function(){
  
  }
  
  //parse smileys:
  Message.prototype.parseMessageBody = function(){
    try{
    	this.body = this.body.replace(/\n/g,"<br />",$str);
  		//this.body = this.body.replace("\'","'",this.body);
  		//this.body = this.body.replace('\"','"',this.body);
  		this.body = this.body.replace(/:D/g, 			    "<img src=\"/images/smile-biggrin.gif\" alt=\":D or :o)\">");
  		this.body = this.body.replace(/:o/g, 			    "<img src=\"/images/smile-biggrin.gif\" alt=\":D or :o)\">");
  		this.body = this.body.replace(/:confused:/g, 	"<img src=\"/images/smile-conf.gif\" alt=\":confused:\">");
  		this.body = this.body.replace(/:cool:/g, 		  "<img src=\"/images/smile-cool.gif\" alt=\":cool:\">");
  		this.body = this.body.replace(/:eek:/g, 		  "<img src=\"/images/smile-eek.gif\" alt=\":eek:\">");
  		this.body = this.body.replace(/:\(/g, 			    "<img src=\"/images/smile-frown.gif\" alt=\":(\">");
  		this.body = this.body.replace(/:-\(/g, 			  "<img src=\"/images/smile-frown.gif\" alt=\":-(\">");
  		this.body = this.body.replace(/:mad:/g, 		  "<img src=\"/images/smile-mad.gif\" alt=\":mad:\">");
  		this.body = this.body.replace(/:o/g, 			    "<img src=\"/images/smile-redface.gif\" alt=\":o or :O\">");
  		this.body = this.body.replace(/:O/g, 			    "<img src=\"/images/smile-redface.gif\" alt=\":o or :O\">");
  		this.body = this.body.replace(/:rolleyes:/g, 	"<img src=\"/images/smile-rolleyes.gif\" alt=\":rolleyes:\">");
  		this.body = this.body.replace(/:-\)/g, 			  "<img src=\"/images/smile-smile.gif\" alt=\":-)\">");
  		this.body = this.body.replace(/:\)/g, 			    "<img src=\"/images/smile-smile.gif\" alt=\":)\">");
  		this.body = this.body.replace(/:P/g, 			    "<img src=\"/images/smile-tongue.gif\" alt=\":P\">");
  		this.body = this.body.replace(/;-\)/g, 			  "<img src=\"/images/smile-wink.gif\" alt=\";-)\">");
  		this.body = this.body.replace(/;\)/g, 			    "<img src=\"/images/smile-wink.gif\" alt=\";)\">");
  		this.body = this.body.replace(/:scool:/g, 		"<img src=\"/images/smile-evil.gif\" alt=\":scool:\">");
  		this.body = this.body.replace(/:rtfm:/g, 		  "<img src=\"/images/smile-rtfm.gif\" alt=\":rtfm:\">");
  		this.body = this.body.replace(/:hat:/g, 		  "<img src=\"/images/smile-hat.gif\" alt=\":hat:\">");
  		this.body = this.body.replace(/:bonk:/g, 		  "<img src=\"/images/smile-bonk.gif\" alt=\":bonk:\">");
  		this.body = this.body.replace(/:rocket:/g, 	  "<img src=\"/images/smile-rocket.gif\" alt=\":rocket:\">");
  		this.body = this.body.replace(/:worthy:/g, 	  "<img src=\"/images/smile-worthy.gif\" alt=\":worthy:\">");
  		this.body = this.body.replace(/:nono:/g, 		  "<img src=\"/images/smile-nono.gif\" alt=\":nono:\">");
  		this.body = this.body.replace(/:argh:/g, 		  "<img src=\"/images/smile-wall.gif\" alt=\":argh:\">");
  		this.body = this.body.replace(/:bubble:/g, 	  "<img src=\"/images/smile-otc.gif\" alt=\":bubble:\">");
  		this.body = this.body.replace(/{ROTFL}/g, 		"<img src=\"/images/rotfl.gif\" alt=\"Roll on the floor laughing\">");
  		this.body = this.body.replace(/{BLAH}/g, 		  "<img src=\"/images/blahblah.gif\" alt=\"blah blah\">");
  		this.body = this.body.replace(/{LOL}/g, 		  "<img src=\"/images/LOL.gif\" alt=\"Laughs out loud\">");
    }
    catch(e){
      
    }
  }
}

%>
