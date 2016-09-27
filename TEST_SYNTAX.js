/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


    if(asJSON){
        for(var a=0;a<treeNodes.length;a++){
            currPage = new Page(treeNodes[a].pageId);
            if(currPage.linkText){
                currLinkText = currPage.linkText;  
            }
            else{
                currLinkText = "[node=" + treeNodes[a].id + "]" ;
            }
            /*
            ("{title : '" + currLinkText + "',value : '/ccms.asp?nodeid=" + treeNodes[a].id + "'
                "});
            */
            data.push({title : "\"" + currLinkText + "\",value : \"/ccms.asp?nodeid=" + treeNodes[a].id + "\""});
        }
    }