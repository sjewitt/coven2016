/**
 * JS to interface with covid 19 tracking API(s).
 * [adapted from my Doomworld API code]
 * 
 * See https://about-corona.net/documentation for source
 * 
 */
var covid19engine = {
	PROXY_LOCATION : '/proxy/proxycv19_a.php',	
	COUNTRY_LIST_WRAPPER : 'country_list_wrapper',
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
		
		//Build country dropdown container. AJAX-targeted once built:
		let cell_1_1 = document.createElement('div');
		cell_1_1.setAttribute('class','pure-u-1-5');
		cell_1_1.setAttribute('id',this.COUNTRY_LIST_WRAPPER);
		
		/* build checkboxes for data blocks to display. Default to deaths: */
		let cell_1_2 = document.createElement('div');
		cell_1_2.setAttribute('class','pure-u-3-5 legend');
		cell_1_2.appendChild(this.buildBlocksToDisplayCheckboxes());
		
		/* build submit button: */
		let cell_1_3 = document.createElement('div');
		cell_1_3.setAttribute('class','pure-u-1-10');
		let _go = document.createElement('input');
		_go.setAttribute('type','button');
		_go.setAttribute('value','OK');
		_go.setAttribute('title','Build graph for selected options');
		_go.setAttribute('name','load_data');
		_go.setAttribute('id','load_data');
		cell_1_3.appendChild(_go);
		
		/* append to cells in row: */
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
		
		/* append to outer container and return: */
		_outer.appendChild(row1);
		_outer.appendChild(row2);
		return(_outer);
	},
	
	/**
	 * retrieve the source JSON data via AJAX call, using PHP local proxy:
	 * */
	loadCountries : function(container){
		let _url = this.PROXY_LOCATION;
		$('#' + this.COUNTRY_LIST_WRAPPER).append(this.spinner);
		$.ajax({
            type: "GET",
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            url : _url
        }).done(function(data){
        	/* sort by name, not country code: */
        	data.data.sort(function(a,b){
        		if(a.name<b.name) return(-1);
        		if(a.name>b.name) return(1);
        		return(0);
        	})
        	console.log('All countries: ',data);
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
		let _target = $("#" + this.COUNTRY_LIST_WRAPPER);
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
			let _elm = $('#covid19_api select')[0];
			let _selected = _elm[_elm.selectedIndex].value;

			/* collect checked data blocks and populate global var: */
			covid19engine.getSelectedBlockValues();
			covid19engine.loadCountryDetails(_selected,container);
		});
	},

	/**
	 * set the global this.dataBlocks[n].display values accordinng to 
	 * selected checkboxes:
	 */
	getSelectedBlockValues : function(){
		$('#chk_datablock').find('input').each(function(){
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
		
		/* AJAX to get details: */
		$('#output_target').append(this.spinner);
		$.ajax({
            type: "GET",
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            url : covid19engine.PROXY_LOCATION + "?code=" + cc
        }).done(function(data){
        	console.log('selected country:',data);
       		//call func to build details panel
        	$('#output_target').empty();
        	
    		/* now we have the blocks to display, we calculate the scalefactor: * */
        	covid19engine.SCALEFACTOR = covid19engine.GRAPH_HEIGHT/covid19engine.getScaleFactor(data);
        	covid19engine.buildOutput(data);
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
		let colnum=0;
		for(let z = data.data.timeline.length; z > 0; z--){
			this.buildDataColumn(data.data.timeline[z-1],colnum);
			colnum++;
		}
		console.log('total columns: ', colnum);
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
    				if( data.data.timeline[z][prop] > _m[prop] ){
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
		
		/* append click handlers to chckboxes, to autoclick the go button: */
		$(_wrapper).find('input').each(function(){
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
		let cls = 'datacol';
		if(colnum%2){
			cls += ' odd';
		}
		col.setAttribute('class',cls);
		col.setAttribute('data-date',data['date']);
		col.setAttribute('title',data['date'] + ' colnum='+colnum);
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
				block.setAttribute('data-datablock',item);
				block.setAttribute('style','width:'+(this.COL_WIDTH-1)+'px;height:'+data[item]*covid19engine.SCALEFACTOR + 'px');
				//block.setAttribute('style','width:3px;height:'+data[item]*covid19engine.SCALEFACTOR + 'px');
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

