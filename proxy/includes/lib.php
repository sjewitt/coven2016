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
            # echo $value . ', ';
            array_push($_param_string_array, $key . '=' . $value);
        }
        # echo 'PARAMETERS: '.$_param_string_array;
        # fixed for PHP8. See https://www.php.net/manual/en/migration74.deprecated.php (implode())
        $query_string = implode('&',$_param_string_array);       # implode($_param_string_array,'&');
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
        
        /*
         * See: https://stackoverflow.com/questions/26148701/file-get-contents-ssl-operation-failed-with-code-1-failed-to-enable-crypto
         * LOCAL DEV ONLY!!
         * */
        $arrContextOptions=array(
            "ssl"=>array(
                "verify_peer"=>false,
                "verify_peer_name"=>false,
            ),
        );
        
        
        $response = file_get_contents("https://maps.co.weber.ut.us/arcgis/rest/services/SDE_composite_locator/GeocodeServer/findAddressCandidates?Street=&SingleLine=3042+N+1050+W&outFields=*&outSR=102100&searchExtent=&f=json", false, stream_context_create($arrContextOptions));
        
        
        return(file_get_contents($req, false, stream_context_create($arrContextOptions)));
    }
}