/**
 * JS to interface with covid 19 tracking API(s).
 * [adapted from my Doomworld API code]
 */
var covid19engine = {
	PROXY_LOCATION : '/proxy/proxycv19_a.php',	
	container : null,
	GRAPH_HEIGHT : 1000,
	COL_WIDTH : 5,
	SCALEFACTOR : 1,
	
	dataBlocks : {
		'active':{'display' : false, 'displayName':'Active'},
		'confirmed':{'display' : false, 'displayName':'Confirmed'},
		'new_confirmed':{'display' : false, 'displayName':'New confirmed'},
		'deaths':{'display' : true, 'displayName':'Deaths'},
		'new_deaths':{'display' : false, 'displayName':'New deaths'},
		'new_recovered':{'display' : false, 'displayName':'New recovered'},
		'recovered':{'display' : false, 'displayName':'Recovered'}
	},
	
	
	/**
	 * Dec 2020:
	 * Load the framework and build the UI elements:
	 * 
	 *  - dropdown for countries
	 *  - filter for data blocks (current, recovered, deaths etc.)
	 *  - OK button
	 *  - div for data (don't hide controls). Let this div be horizontally scrollable wih a fixed height
	 *    (1000px?) and scale to that VERTICALLY rather than horizontally (better graph)
	 *  - also, build graph manually as I don't get D3 yet...
	 * 
	 * 12/20: called by controller.js, based on the json hierarchy data.
	 * This needs to retain the title block and populate the body block...
	*/
	init : function(container){
		this.spinner = document.createElement('img');
		this.spinner.setAttribute('src','/images/spinner.gif');
		this.spinner.setAttribute('class','spinner');
		let _container = 'covid19_api_a';	//Dec 2020: this is the container for the whole thing!
		if(container){
			_container = container;
		}
		let _f = $('#' + _container + " > div.panel-text");
		_f.empty();
		_f[0].appendChild(this.buildUIFramework());
		
		/*
		 * once we have the basic famework, load the country dropdowm. This is an AJAX call:
		 * */
		this.loadCountries(_container);
		//console.log(this.buildBlocksToDisplayCheckboxes());
	},
	
	/**
	 * Build a wrapper into which the UI goes. Append to outer container.
	 * */
	buildUIFramework : function(container){
		//wrapper:
		let _outer = document.createElement('div');
		
		//top row - controls:
		let row1 = document.createElement('div');
		row1.setAttribute('class','pure-g');	//3 elems
		
		//country dropdown () AJAX-targeted once built:
		let cell_1_1 = document.createElement('div');
		cell_1_1.setAttribute('class','pure-u-1-5');
		cell_1_1.setAttribute('id','country_list_wrapper');
		
		//data blocks to display (checkboxes). Call function with default selected (deaths):
		let cell_1_2 = document.createElement('div');
		cell_1_2.setAttribute('class','pure-u-3-5 legend');
		
		cell_1_2.appendChild(this.buildBlocksToDisplayCheckboxes());
		
		//go button
		let cell_1_3 = document.createElement('div');
		cell_1_3.setAttribute('class','pure-u-1-10');
		let _go = document.createElement('input');
		_go.setAttribute('type','button');
		_go.setAttribute('value','OK');
		_go.setAttribute('title','Build graph for selected options');
		_go.setAttribute('name','load_data');
		_go.setAttribute('id','load_data');
		cell_1_3.appendChild(_go);
		
		row1.appendChild(cell_1_1);
		
		row1.appendChild(cell_1_3);
		row1.appendChild(cell_1_2);
		
		/* container for output */
		let row2 = document.createElement('div');
		row2.setAttribute('class','pure-g');	//1 elem
		
		let cell_2_1 = document.createElement('div');
		cell_2_1.setAttribute('class','pure-u-1');
		cell_2_1.setAttribute('id','output_target');
		row2.appendChild(cell_2_1);
		
		_outer.appendChild(row1);
		_outer.appendChild(row2);
		return(_outer);
	},
	
	/**
	 * retrieve the source JSON data via AJAX call, using PHP local proxy:
	 * */
	loadCountries : function(container){
		let _url = this.PROXY_LOCATION;
		$('#country_list_wrapper').append(this.spinner);
		$.ajax({
            type: "GET",
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            url : _url
        }).done(function(data){
        	data.data.sort(function(a,b){
        		console.log('sortin')
        		if(a.name<b.name) return(-1);
        		if(a.name>b.name) return(1);
        		return(0);
        	})
       		covid19engine.buildCountrySelector(data);
       		covid19engine.appendButtonHandler(container);
        }).fail(function(a,b,c){
        	console.log(a,b,c);
        });
	},

	/**
	 * Build dropdown of all countries:
	 * */
	buildCountrySelector : function(data){
		let _target = $("#country_list_wrapper");
		let _sel = document.createElement('select');
		
		for(let a=0;a<data.data.length;a++){
			let _opt = document.createElement('option');
			_opt.setAttribute('value',data.data[a].code);
			_opt.setAttribute('data-countrycode',data.data[a].code);
			var _txt = document.createTextNode(data.data[a].name);
			_opt.appendChild(_txt);
			_sel.appendChild(_opt);
		}

		_target.empty();
		_target.append(_sel);
	},
	
	/**
	 * set the click handler for the go button:
	 * */
	appendButtonHandler : function(container){
		$('#load_data').click(function(){
			//collect the data to send 
//=======
//		$(_target).off('change click').on('change',function(){
//>>>>>>> branch 'html_php' of https://github.com/sjewitt/coven2016.git
			let _elm = $('#covid19_api select')[0];
			console.log(_elm);
			let _selected = _elm[_elm.selectedIndex].value;
//<<<<<<< HEAD
			//let _dataBlocks = {};
			
			/* collect checked data blocks and populate global var: */
			covid19engine.getSelectedBlockValues();
			
			
			
//=======
//>>>>>>> branch 'html_php' of https://github.com/sjewitt/coven2016.git
			console.log(_selected);
			covid19engine.loadCountryDetails(_selected,container);

			//we need to use the new scalefactor code here!
		});
//<<<<<<< HEAD
//=======
		
		//this.buildCountryClickHandlers(container);
//>>>>>>> branch 'html_php' of https://github.com/sjewitt/coven2016.git
	},
	
//<<<<<<< HEAD
	/**
	 * set the global this.dataBlocks[n].display values accordinng to 
	 * selected checkboxes:
	 */
	getSelectedBlockValues : function(){
		$('#chk_datablock').find('input').each(function(){
			console.log($(this).attr('data-block'));
			console.log($(this)[0].checked);
			//reset
			covid19engine.dataBlocks[$(this).attr('data-block')]['display'] = false;
			if($(this)[0].checked){
				covid19engine.dataBlocks[$(this).attr('data-block')]['display'] = true;
			}
		});
	},
	


	/**
	 * retrieve the specified country details as JSON via AJAX call, using local PHP proxy:
	 */
	loadCountryDetails : function(cc,container){
		
		/*
		 * AJAX to get details:
		 * */
		$('#output_target').append(this.spinner);
		$.ajax({
            type: "GET",
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            url : covid19engine.PROXY_LOCATION + "?code=" + cc
        }).done(function(data){
//<<<<<<< HEAD

        	console.log(data);
       		//call func to build details panel
        	$('#output_target').empty();
        	
        	let width = 1200;
        	console.log(covid19engine.dataBlocks);
    		/*
    		 * now we have the blocks to display, we calculate the scalefactor:
    		 * */
        	
        	//covid19engine.buildD3Output(data);
        	
        	
        	//let _TESTcurrmax = covid19engine.getScaleFactor(data,{'active':false,'confirmed':false,'new_confirmed':false,'deaths':true,'new_deaths':false,'new_recovered':false,'recovered':false});
        	let _TESTcurrmax = covid19engine.getScaleFactor(data);
        	let _TESTscalefactor = 1;
        	_TESTscalefactor = width/_TESTcurrmax
//        	console.log("scale (test):", _TESTscalefactor);
        	covid19engine.SCALEFACTOR = covid19engine.GRAPH_HEIGHT/_TESTcurrmax
//        	console.log("scale (test):", covid19engine.SCALEFACTOR);
        	covid19engine.buildOutput(data);
//=======
//        	//call func to build details panel
//        	$('#'+container + " > div.panel-text").empty();
//        	//see https://www.tutorialsteacher.com/d3js/create-svg-chart-in-d3js
//        	
//        	let d3data = data.data.timeline;
//        	console.log(d3data.length);
//        	let width = 1200;
//        	let barHeight = 20;
//        	let graph = d3.select('#'+container + " > div.panel-text")
//        		.append('svg')
//        		.attr("width", width)
//        		.attr("height", barHeight * d3data.length);
//        	
//        	//in preparation for stacking:
//        	let _fields = ['recovered'];
//        	
//        	//make a STACK object: https://github.com/d3/d3-shape/blob/v1.3.7/README.md#_stack
//        	let _stack = d3.stack();
//        	//set headings:
//        	_stack.keys(_fields);
//        	let _series = _stack(d3data);
//        	
//        	console.log(_series);
//        	//let _x = d3.scaleBand
//        	
//        	
//        	let scaleFactor = 1;
//            
//        	let maxCombinedValue = 0;
//        	let _currentCombinedValue = 0;
//        	for(let a=0;a<d3data.length; a++){
//        		for(let b=0; b<_fields.length; b++){
//        			_currentCombinedValue = d3data[a][_fields[b]];
//        		}
//        		if(maxCombinedValue < _currentCombinedValue){
//        			maxCombinedValue = _currentCombinedValue;
//        		}
//            }
//            //work out the scalefactor:
//            // - max value from data. This needs to be the max for selected field(s). IE max(f1+f2) 'cos we want a ROW
//            scaleFactor = width / maxCombinedValue;
//
//        	 let bar = graph.selectAll("g")
//             .data(d3data)
//             .enter()
//             .append("g")
//             .attr("transform", function(d, i) {
//                   return "translate(0," + i * barHeight + ")";
//             });
//        	 
//        	 bar.append("rect")
//             .attr("width", function(d) {
//            	 //console.log(d['recovered']);
//                 return d['recovered'] * scaleFactor;
//		        })
//		        .attr("height", barHeight - 1);
//		
//		     bar.append("text")
//		        .attr("x", function(d) { return (d['recovered']*scaleFactor); })
//		        .attr("y", barHeight / 2)
//		        .attr("dy", ".35em")
//		        .text(function(d) { return d['recovered']; });
//		     
//        	let _return = document.createElement('div');
//        	_return.setAttribute('id','cv19_home');
//        	let _txt = document.createTextNode('[Back]');
//        	_return.appendChild(_txt);
//        	$('#'+container + " > div.panel-text").append(_return);
//        	//add handler for return:
//        	$('#cv19_home').click(function(){
//        		$('#'+container + " > div.panel-text").empty();
//        		covid19engine.loadCountries(container);
//        	});
        	//then apend a link to go back
//>>>>>>> branch 'html_php' of https://github.com/sjewitt/coven2016.git
        }).fail(function(a,b,c){
        	console.log(a,b,c);
        });
	},
	
	/**
	 * build graph of data, based on selected data blocks and calculated scaling factor.
	 * The output is a horizontally scrollable DIV with vertical scaled values and horizontal
	 * time. Scale is different depending on which data blocks are selected.
	 * */
	buildOutput : function(data){
//		for(let z=0;z<data.data.timeline.length;z++){
		let colnum=0;
		for(let z = data.data.timeline.length; z > 0; z--){
			this.buildDataColumn(data.data.timeline[z-1],colnum);
			colnum++;
		}
	},
	
	buildD3Output : function(data){
		//D3 hook:
    	console.log('D3 hook start');
    	let width = 1200;
    	//see https://www.tutorialsteacher.com/d3js/create-svg-chart-in-d3js
    	let d3data = data.data.timeline;
    	//console.log(data.data.timeline);
    	
    	
    	let _currmax = 0;
   		//work out max
    	for(let z=0;z<data.data.timeline.length;z++){
    		if(data.data.timeline[z].deaths){
    			if(data.data.timeline[z].deaths > _currmax){
    				_currmax = data.data.timeline[z].deaths;
    			}
    		}
    	}
    	
    	
    	
   		//_currmax = data.data.timeline[data.data.timeline.length-1].deaths
    	console.log("curr max: ",_currmax);
   		
    	
        //scaleFactor = 1,
    	scaleFactor = width/_currmax;
    	
    	console.log("scale:", scaleFactor);
    	
        barHeight = 20;
    	//let graph = d3.select("body").append('svg')
    	let graph = d3.select('#output_target').append('svg')
        .attr("width", width)
        .attr("height", barHeight * d3data.length);

    	console.log(d3data.length);
    	 let bar = graph.selectAll("g")
         .data(d3data)
         .enter()
         .append("g")
         .attr("transform", function(d, i) {
               return "translate(0," + i * barHeight + ")";
         });
    	
    	 
    	 bar.append("rect")
         .attr("width", function(d) {
        	 //console.log(d['deaths']);
             return d['deaths'] * scaleFactor;
	        })
	        .attr("height", barHeight - 1);
	
	     bar.append("text")
	        .attr("x", function(d) { return (d['deaths']*scaleFactor); })
	        .attr("y", barHeight / 2)
	        .attr("dy", ".35em")
	        .text(function(d) { return d['deaths']; });

    	let _return = document.createElement('div');
    	_return.setAttribute('id','cv19_home');
    	let _txt = document.createTextNode('[Back]');
    	_return.appendChild(_txt);
    	$('#output_target').append(_return);
    	return(true);
	},
	
	/**
	 * get a scalefactor for height, based on max height of selected data blocks
	 * data = all data
	 * dataBlocks = array of data block names to consider as {name:bool,name:bool}
	 * 
	 * */
	getScaleFactor : function(data){
		let _currmax = 0;
   		//work out max
		
//<<<<<<< HEAD
		//need individual vars for each total:
		let _m = {
			'active':0,
			'confirmed':0,
			'deaths':0,
			'new_confirmed':0,
			'new_deaths':0,
			'new_recovered':0,
			'recovered':0
		}
		
    	for(let z=0;z<data.data.timeline.length;z++){
    		for(prop in this.dataBlocks){
    			if(this.dataBlocks[prop]['display']){
    				if( 
    						data.data.timeline[z][prop] > _m[prop]
    				){
    					console.log(prop, _m[prop], data.data.timeline[z][prop]);
    					_m[prop] = data.data.timeline[z][prop];
    				}
    			}
    		}	
    	}
		
		/*
		 * once we have the max heights for each flagged data block, 
		 * simply add them up and divide max width by this.
		 */
		for(prop in _m){
			_currmax += _m[prop];
		}
		return(_currmax);
	},
	
	/**
	 * build a set of checkboxes to optionally display 
	 * different data blocks:
	 * 'flagged': object containing block IDs(?) and a boolean (do I need to send ALL)?
	 * If not present, assume default as specified in this.dataBlocks.
	 */
	buildBlocksToDisplayCheckboxes : function(flagged){
		_active = {'deaths':true};
		if(flagged){
			_active = flagged;
		}
		let _wrapper = document.createElement('ul');
		_wrapper.setAttribute('id','chk_datablock');
		for(prop in this.dataBlocks){
			let _li = document.createElement('li');
			_li.setAttribute('class',prop);
			let _chk = document.createElement('input');
			_chk.setAttribute('type','checkbox');
			_chk.setAttribute('name','blockvalues');
			_chk.setAttribute('data-block',prop);
			
			_chk.setAttribute('id','chk_'+prop);
			for(thing in _active){
				if(_active[thing] === true && prop === thing){
					_chk.setAttribute('checked','checkbox');
				}
			}
			let _txt = document.createTextNode(this.dataBlocks[prop]['displayName']);
			_li.appendChild(_chk);
			_li.appendChild(_txt);
			_wrapper.appendChild(_li);
		}
		
		//append click handlers:
		$(_wrapper).find('input').each(function(){
			console.log('appendin')
			$(this).click(function(){
				console.log('klikkin')
				$('#load_data').click();
			});
		});
		
		return(_wrapper);
	},
	
	/**
	 * build a single column of data, with scaleFactor and one or more blocks:
	 * */
	buildDataColumn : function(data, colnum){
		let col = document.createElement('div');
		col.setAttribute('class','datacol');
		col.setAttribute('data-date',data['date']);
		col.setAttribute('title',data['date']);
		col.setAttribute('style',';left:'+colnum*this.COL_WIDTH+'px;')
		/*
		 * here, I test each data against the flagged data blocks to display:
		 * */
		for(item in this.dataBlocks){
			if(this.dataBlocks[item]['display']){
				let block = document.createElement('div');
				block.setAttribute('class','datablock '+item);
				block.setAttribute('title',data[item]);
				block.setAttribute('data-total',data[item]);
				block.setAttribute('data-datablock',item)
				block.setAttribute('style','width:3px;height:'+data[item]*covid19engine.SCALEFACTOR + 'px');
				col.appendChild(block);
			}
		}
		let _target = document.getElementById('output_target');
		_target.appendChild(col);
	},	
	
	
	getQuerystring : function(){
		return(window.location.search);
	}
};

