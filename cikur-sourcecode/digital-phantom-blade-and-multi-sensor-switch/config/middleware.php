<?php

/*
 * This file is part of the Slim API skeleton package
 *
 * Copyright (c) 2016 Mika Tuupola
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Project home:
 *   https://github.com/tuupola/slim-api-skeleton
 *
 */
use App\Token;

$container = $app->getContainer();
$container['db'] = function () {
    $dsn = 'mysql:host=' . getenv("DB_HOST") . ';dbname=' . getenv("DB_NAME") . ';charset=utf8';
    $usr = getenv("DB_USER");
    $pwd = getenv("DB_PASSWORD");
    return new Slim\PDO\Database($dsn, $usr, $pwd);
};

$container['renderer'] = new \Slim\Views\PhpRenderer(__DIR__ . "/../views");