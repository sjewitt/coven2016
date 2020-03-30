<?php
/*
 * Simple proxy for connecting with ID Games API
 */
class proxy{
    const api_root = 'https://www.doomworld.com/idgames/api/api.php';
    
    const api_root_cv19_a = 'https://corona-api.com/countries';
    
    function __construct(){ }
    
    function doRequest($request){
        /*
         * work out what to do here? or just use dumb
         * */
        $_param_string_array = Array();
        foreach ($_GET as $key => $value) { 
            array_push($_param_string_array, $key . '=' . $value);
        }
        $query_string = implode($_param_string_array,'&');
        return(file_get_contents(self::api_root . '?' . $query_string . '&out=json'));
    }
    
    /*
     * For https://corona-api.com/countries
     * */
    function doCV19Request_a($country){
        $req = self::api_root_cv19_a;
        $val = false;
        foreach ($_GET as $key => $value) {
            if($key == 'code'){
                $val = $value;
            }
        }
        
        if($val){
            $req = $req . "/" . $val;
        }
        return(file_get_contents($req));
    }
}