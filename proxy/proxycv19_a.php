<?php
include "includes/lib.php";

$_p = new proxy();
header('Content-Type: application/json');
/**
 * expose endpoints
 * */
echo $_p->doCV19Request_a($_GET);
