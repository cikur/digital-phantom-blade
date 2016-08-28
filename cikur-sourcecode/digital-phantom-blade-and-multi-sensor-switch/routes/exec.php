<?php
/**
 * Created by PhpStorm.
 * User: ark
 * Date: 8/28/2016
 * Time: 12:59 AM
 */

$app->get('/exec[/{id}]', function($req,$res,$arg){
    echo  exec('dir');
});

$app->get('/1exec[/{id}]', function($req,$res,$arg){
    return exec('dir');
});

$app->get('/2exec[/{id}]', function($req,$res,$arg){
    return exec('dir');
});

$app->get('/3exec[/{id}]', function($req,$res,$arg){
    return exec('dir');
});