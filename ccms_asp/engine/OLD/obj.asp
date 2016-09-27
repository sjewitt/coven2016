<%
function obj(id){
  obj.prototype.id = id;
  obj.prototype.content = "[none set]";
  obj.prototype.getId = function(){
    return this.id;
  }
  obj.prototype.getContent = function(){
   switch(this.id){
    case 1:
      this.content = "content 1";
    break;
    case 2:
      this.content = "content 2";
    break;
    case 3:
      this.content = "content 3";
    break;
    case 4:
      this.content = "content 4";
    break;
   }
   return(this.content);
  }
}
%>
