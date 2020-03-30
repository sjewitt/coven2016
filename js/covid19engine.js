/**
 * JS to interface with ID archive API.
 * 
 * ?action=getdirs&name=levels/doom2/
 */
var covid19engine = {
	PROXY_LOCATION : '/proxy/proxycv19_a.php',	
	init : function(container){
		let _container = 'covid19_api_a';
		if(container){
			_container = container;
		}

		this.loadCountries(false,_container,_container);
		this.spinner = document.createElement('img');
		this.spinner.setAttribute('src','/images/spinner.gif');
	},
	
	loadCountries : function(branch,target,container){
		console.log("loading data");
		let _url = covid19engine.PROXY_LOCATION;
//		if(branch){
//			_url = covid19engine.PROXY_LOCATION + "?action=getdirs&name=" + branch;
//		};
		$('#'+target).find('div.spinner_wrapper').append($(covid19engine.spinner).clone());
		var _target = target;
		console.log(_url);
		$.ajax({
            type: "GET",
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            url : _url
        }).done(function(data){
        	console.log(data);
        	/* check whether the response is a directory list: */
//        	if(data['content'] && data['content']['dir']){
        		covid19engine.buildCountryLinks(data,_target,container);
//        	}
        	/* if not, assume a file list */
//        	else{
//        		covid19engine.loadFiles(branch,_target);
//        	};
        }).fail(function(a,b,c){
        	console.log(a,b,c);
        });
	},
	
	loadFiles : function(branch,target,loadedBefore){
		var _url = covid19engine.PROXY_LOCATION + "?action=getfiles&name=" + branch;
		var _target = target;
		$.ajax({
            type: "GET",
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            url : _url
        }).done(function(data){
        	if(data['content'] && data['content']['file']){
        		covid19engine.buildFileLinks(data,_target);
        	}
        });
	},

	buildCountryLinks : function(data,  target,container){
		var _out = "";
		var _ul = document.createElement('ul');
		_ul.setAttribute('class','doombrowser');
		
		console.log(data);
		for(let a=0;a<data.data.length;a++){
			let _li = document.createElement('li');
//			$('#'+target).append(data.data[a].name + "<br />");
			var _a1 = document.createElement('a');
			_a1.setAttribute('href',covid19engine.PROXY_LOCATION + "?code=" + data.data[a].code);
			
			var _txt = document.createTextNode(data.data[a].name);
			_a1.appendChild(_txt);
			_li.appendChild(_a1);
			_ul.appendChild(_li);
		}
		console.log(_ul);
		console.log('#'+target + " > div.panel-text")
		var _target = $('#'+target + " > div.panel-text");
		_target.append(_ul);
	},

	buildFileLinks : function(data, target){
		var _target = document.getElementById(target);
		var _out = "";
		var ftp_root = "ftp://ftp.fu-berlin.de/pc/games/idgames/";
		var _ul = document.createElement('ul');
		if(data.content.file){
			/* as for directories, if only one result, we don't get an array... */
			let _files = new Array();
			if(data.content.file[0] === undefined){
				_files[0] = data.content.file;
			}
			else{
				_files = data.content.file;
			}
			for(var a=0;a<_files.length; a++){
				var _li = document.createElement('li');
				_li.setAttribute('data-loaded','false');
				_li.setAttribute('id','tree_'+_files[a].id);
				
				var _div = document.createElement('div');
				_div.setAttribute('class', 'tree-toggler closed');
				_div.setAttribute('data-loaded','false');
				_div.setAttribute('data-target','tree_'+_files[a].id);
				
				var _span = document.createElement('span');
				let _desc = '[no description found]';
				if(_files[a].description){
					_desc = _files[a].description.replace(/\<br\>/g,'\n');
				}
				let _title = _files[a].filename;
				if(_files[a].title){
					_title = _files[a].title
				}
				var _a1 = document.createElement('a');
				_a1.setAttribute('title',_desc);
				_a1.setAttribute('href',ftp_root + _files[a].dir + _files[a].filename);
				
				var _txt = document.createTextNode(_title);
				_a1.appendChild(_txt);
				_li.appendChild(_div);
				_li.appendChild(_a1);
				_ul.appendChild(_li);
			}
			_target.appendChild(_ul);
			/* remove spinner when done building the childs: */
			$(_target).find('div.spinner_wrapper > img').remove();
		}
	},
	
	/**
	 * toggle visibility of child <li> elements 
	 * and also the folder class of the toggler <div>
	 * */
	toggleBranch : function(togglerId){
		var _thing = $('#'+togglerId).find('ul').first();
		
		if(_thing.hasClass('hidden')){
			$('#'+togglerId).find('i').first().removeClass('fa-folder').addClass('fa-folder-open');
			_thing.removeClass('hidden');
		}
		else{
			$('#'+togglerId).find('i').first().removeClass('fa-folder-open').addClass('fa-folder');
			_thing.addClass('hidden');
		}
	},
	
	getQuerystring : function(){
		return(window.location.search);
	}
};
//$(function(){engine.init();})
