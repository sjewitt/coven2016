<%
/*
ASP javascript implementation of
hierarchical forum. Based on
Obtree sForum...
*/

function Forum(){
  this.test = "arse";
  //insert user's registration details:
  Forum.prototype.register = function(user,email,password){
    //check that user email does not exist:
    
    //if not, insert user in INACTIVE state:
    
    //prepare email holding confirmation return link:
  }

  //set the database flag on the user to true if they confirm:
  Forum.prototype.confirmRegistration = function(email){
    //check that the email is in the database:
    
    //if so, set the user active
  }
  
  //log in the user:
  Forum.prototype.authenticate = function(email,password){
    
    
  }
  
  //reset password for supplied email. Check it exists in DB first...
  Forum.prototype.passwordReset = function(email){
    
  }
  
  Forum.prototype.getUserById = function(userId){
    try{
      return new User(userId);
    }
    catch(e){
      
    }
  }
  
  //construct a 
  Forum.prototype.createMessageObject = function(messageId,threadId,parentId,title,body,date,userId){
    try{
      var msgObject = new Object();
      msgObject.messageId   = messageId;
      msgObject.threadId    = threadId
      msgObject.parentId    = parentId
      msgObject.title       = title
      msgObject.body        = body
      msgObject.date        = date
      msgObject.createdUser = this.getUserById(userId)
      
    }
    catch(e){
      
    }
  }
}


%>
