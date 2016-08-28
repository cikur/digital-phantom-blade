<?php
session_start();
if (!function_exists('session_set')) {
    function session_set($name, $param)
    {
        $_SESSION[base64_encode($name)] = $param;
    }
}
if (!function_exists('session')) {
    function session($name)
    {
        if (isset($_SESSION[base64_encode($name)])) {
            return $_SESSION[base64_encode($name)];
        }
        return false;
    }
}
if (!function_exists('session_del')) {
    function session_del($name)
    {
        if ($_SESSION[base64_encode($name)]) {
            unset($_SESSION[base64_encode($name)]);
        }
    }
}
require __DIR__ . "/../app.php";
