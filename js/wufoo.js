/*
 * build wufoo form:
 */

var wufoo = {
    page : null,
    
    init : function(pageObj){
        console.log("Wufoo form loading...");
        this.page = pageObj;
        var src_temp = '<form id="form1" name="form1" class="wufoo topLabel page" accept-charset="UTF-8" autocomplete="off" enctype="multipart/form-data" method="post" novalidate action="https://jcmssilas.wufoo.com/forms/z157nixr1oirgiy/#public"><header id="header" class="info"><h2>Get in touch</h2><div>Pleas fill in your details and needs and we will get back to you shortly.</div></header><ul><li id="foli1" class="notranslate"><label class="desc" id="title1" for="Field1">Name</label><span><input id="Field1" name="Field1" type="text" class="field text fn" value="" size="8" tabindex="1" /><label for="Field1">First</label></span><span><input id="Field2" name="Field2" type="text" class="field text ln" value="" size="14" tabindex="2" /><label for="Field2">Last</label></span></li><li id="foli3" class="notranslate"><label class="desc" id="title3" for="Field3">Email</label><div><input id="Field3" name="Field3" type="email" spellcheck="false" class="field text medium" value="" maxlength="255" tabindex="3" /></div></li><li id="foli4" class="notranslate"><label class="desc" id="title4" for="Field4">Your message</label><div><textarea id="Field4" name="Field4" class="field textarea medium" spellcheck="true" rows="10" cols="50" tabindex="4" onkeyup="" ></textarea></div></li><li class="buttons"><div><input id="saveForm" name="saveForm" class="btTxt submit" type="submit" value="Submit" /></div></li><li class="hide"><label for="comment">Do Not Fill This Out</label><textarea name="comment" id="comment" rows="1" cols="1"></textarea><input type="hidden" id="idstamp" name="idstamp" value="4OmMIKthKce7wuHEVj62nALcj1oJFs3sD8tfYS/mWgU=" /></li></ul></form>';
        //var src_plugin = '<div id="wufoo-z157nixr1oirgiy">Fill out my <a href="https://jcmssilas.wufoo.com/forms/z157nixr1oirgiy">online form</a>.</div><div id="wuf-adv" style="font-family:inherit;font-size: small;color:#a7a7a7;text-align:center;display:block;">HTML Forms powered by <a href="http://www.wufoo.com">Wufoo</a>.</div><script type="text/javascript">var z157nixr1oirgiy;(function(d, t) {var s = d.createElement(t), options = {\'userName\':\'jcmssilas\',\'formHash\':\'z157nixr1oirgiy\',\'autoResize\':true,\'height\':\'520\',\'async\':true,\'host\':\'wufoo.com\',\'header\':\'show\',\'ssl\':true};s.src = (\'https:\' == d.location.protocol ? \'https://\' : \'http://\') + \'www.wufoo.com/scripts/embed/form.js\';s.onload = s.onreadystatechange = function() {var rs = this.readyState; if (rs) if (rs != \'complete\') if (rs != \'loaded\') return;try { z157nixr1oirgiy = new WufooForm();z157nixr1oirgiy.initialize(options);z157nixr1oirgiy.display(); } catch (e) {}};var scr = d.getElementsByTagName(t)[0], par = scr.parentNode; par.insertBefore(s, scr);})(document, \'script\');</script>';
        var src_plugin = '<div id="wufoo-z157nixr1oirgiy">Fill out my <a href="https://jcmssilas.wufoo.com/forms/z157nixr1oirgiy">online form</a>.</div><div id="wuf-adv" style="font-family:inherit;font-size: small;color:#a7a7a7;text-align:center;display:block;">HTML Forms powered by <a href="http://www.wufoo.com">Wufoo</a>.</div><script type="text/javascript">var z157nixr1oirgiy;(function(d, t) {var s = d.createElement(t), options = {\'userName\':\'jcmssilas\',\'formHash\':\'z157nixr1oirgiy\',\'autoResize\':true,\'height\':\'520\',\'async\':true,\'host\':\'wufoo.com\',\'header\':\'show\',\'ssl\':true};s.src = (\'https:\' == d.location.protocol ? \'https://\' : \'http://\') + \'www.wufoo.com/scripts/embed/form.js\';s.onload = s.onreadystatechange = function() {var rs = this.readyState; if (rs) if (rs != \'complete\') if (rs != \'loaded\') return;try { z157nixr1oirgiy = new WufooForm();z157nixr1oirgiy.initialize(options);z157nixr1oirgiy.display(); } catch (e) {}};var scr = d.getElementsByTagName(t)[0], par = scr.parentNode; par.insertBefore(s, scr);})(document, \'script\');</script>';
        
        $("#jcms_contact").html(src_plugin);
        //$("#jcms_contact > .panel-text").html(this.buildForm());
        
        $("#body-content>div.row").css({"min-height":"300px","height":"initial"});
    },
    
    buildForm : function(){
        var form = document.createElement("form");
        form.setAttribute("id","form1");
        form.setAttribute("name","form1");
        form.setAttribute("class","wufoo topLabel page");
        form.setAttribute("accept-charset","UTF-8");
        form.setAttribute("autocomplete","off");
        form.setAttribute("enctype","multipart/form-data");
        
        var ul = document.createElement("ul");
        
        var li_1 = document.createElement("li");
        li_1.setAttribute("id","foli1");
        li_1.setAttribute("class","notranslate");
        
        var li_2 = document.createElement("li");
        li_2.setAttribute("id","foli3");
        li_2.setAttribute("class","notranslate");
        
        var li_3 = document.createElement("li");
        li_3.setAttribute("id","foli4");
        li_3.setAttribute("class","notranslate");
        
        var li_4 = document.createElement("li");
        li_4.setAttribute("class","button");
        
        var li_5 = document.createElement("li");
        li_5.setAttribute("class","hide");
        
        
        
        
        
        console.log(this.page);

        return li_1;
        /*
<form id="form1" name="form1" class="wufoo topLabel page" accept-charset="UTF-8" autocomplete="off" enctype="multipart/form-data" method="post" novalidate action="https://jcmssilas.wufoo.com/forms/z157nixr1oirgiy/#public">
        <header id="header" class="info">
                <h2>Get in touch</h2>
                <div>Pleas fill in your details and needs and we will get back to you shortly.</div>
        </header>
        <ul>
                <li id="foli1" class="notranslate">
                        <label class="desc" id="title1" for="Field1">Name</label>
                        <span>
                                <input id="Field1" name="Field1" type="text" class="field text fn" value="" size="8" tabindex="1" />
                                <label for="Field1">First</label>
                        </span>
                        <span>
                                <input id="Field2" name="Field2" type="text" class="field text ln" value="" size="14" tabindex="2" />
                                <label for="Field2">Last</label>
                        </span>
                </li>
                <li id="foli3" class="notranslate      ">
                        <label class="desc" id="title3" for="Field3">Email</label>
                        <div>
                                <input id="Field3" name="Field3" type="email" spellcheck="false" class="field text medium" value="" maxlength="255" tabindex="3"       />
                        </div>
                </li>
                <li id="foli4" class="notranslate">
                        <label class="desc" id="title4" for="Field4">Your message</label>
                        <div>
                                <textarea id="Field4" name="Field4" class="field textarea medium" spellcheck="true" rows="10" cols="50" tabindex="4" onkeyup="" ></textarea>
                        </div>
                </li> 
                <li class="buttons">
                        <div>
                                <input id="saveForm" name="saveForm" class="btTxt submit" type="submit" value="Submit" />
                        </div>
                </li>
                <li class="hide">
                        <label for="comment">Do Not Fill This Out</label>
                        <textarea name="comment" id="comment" rows="1" cols="1"></textarea>
                        <input type="hidden" id="idstamp" name="idstamp" value="4OmMIKthKce7wuHEVj62nALcj1oJFs3sD8tfYS/mWgU=" />
                </li>
        </ul>
</form>
         */
    }

};


