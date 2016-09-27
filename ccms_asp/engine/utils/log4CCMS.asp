<%
/*
Simple logger.

Usage:
Calling script can obtain a logger by calling the init() method:

	var myLogger = log4CCMS.init();
	
Then, any of the methods may be used:
	myLogger.info("my msg","log src - suggest the object/method name");
	myLogger.trace("my msg","log src - suggest the object/method name");
	
The loglevels are:
TRACE
DEBUG
INFO
WARN
FATAL

If no entry is found in the config file, the level will default to INFO

The config parameter used is LOGLEVEL. Valid values are the log level 
strings above (case doesn't matter)
*/

var log4CCMS = new Object();

//loglevel constants:
log4CCMS.TRACE	= 5;
log4CCMS.DEBUG	= 4;
log4CCMS.INFO		= 3;
log4CCMS.WARN		= 2;
log4CCMS.FATAL	= 1;

//properties:
log4CCMS.currentLogLevel;
log4CCMS.loggingIsActive = false;

//methods
log4CCMS.init = function(){
  var currLogLevel = 'info';
	try{
	 //set logging:
	 if(typeof(LOGGING) != "undefined"){
	   if(LOGGING.toUpperCase() == 'ON')         this.loggingIsActive = true;
	   else if(LOGGING.toUpperCase() == 'OFF')   this.loggingIsActive = false;
	   else                                      this.loggingIsActive = false;
   }
	 //set log level:
	 if(typeof(LOGLEVEL) != "undefined"){
	   currLogLevel = LOGLEVEL;
   }
		switch(currLogLevel.toUpperCase()){
			case 'TRACE':
				this.currentLogLevel = log4CCMS.TRACE;
			break;
			case 'DEBUG':
				this.currentLogLevel = log4CCMS.DEBUG;
			break;
			case 'INFO':
				this.currentLogLevel = log4CCMS.INFO;
			break;
			case 'WARN':
				this.currentLogLevel = log4CCMS.WARN;
			break;
			case 'FATAL':
				this.currentLogLevel = log4CCMS.FATAL;
			break;
			default:
				this.currentLogLevel = log4CCMS.INFO;
		}
	}
	catch(e){
		logger("error in log4CCMS.init(): " + e.message);
	}
	return this;
}

//TRACE
log4CCMS.trace = function(msg, src){
	if(this.currentLogLevel >= this.TRACE && this.loggingIsActive)
		writeLog(msg,src,"TRACE");
}

//DEBUG
log4CCMS.debug = function(msg, src){
	if(this.currentLogLevel >= this.DEBUG && this.loggingIsActive)
		writeLog(msg,src,"DEBUG");
}

//INFO
log4CCMS.info = function(msg, src){
	if(this.currentLogLevel >= this.INFO && this.loggingIsActive)
		writeLog(msg,src,"INFO");
}

//WARN
log4CCMS.warn = function(msg, src){
	if(this.currentLogLevel >= this.WARN && this.loggingIsActive)
		writeLog(msg,src,"WARN");
}

//FATAL
log4CCMS.fatal = function(msg, src){
	if(this.currentLogLevel >= this.FATAL && this.loggingIsActive)
		writeLog(msg,src,"FATAL");
}

/*
Call the generic logger with the data:
*/
function writeLog(msg,src,severity){
	logger("[log4CCMS] " + src + ": " + severity + ": " + msg);
}
%>
