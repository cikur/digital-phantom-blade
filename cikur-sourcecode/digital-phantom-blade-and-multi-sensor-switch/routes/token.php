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

use Ramsey\Uuid\Uuid;
use Firebase\JWT\JWT;
use Tuupola\Base62;

$app->post("/token", function ($request, $response, $arguments) {
    $requested = $request->getParsedBody();
    $user['username'] = isset($requested['username']) ? $requested['username'] : '';
    $user['password'] = isset($requested['password']) ? $requested['password'] : '';

    $identified = $this->db->select()->from('user')
        ->where('username', '=', $user['username'])
        ->where('password', '=', md5($user['password']))
        ->execute()->fetch();


    $future = new DateTime("now +30 days");
    $jti = Base62::encode(random_bytes(16));

    if (!$identified) {
        $payload = [
            "iat" => null,
            "exp" => $future->getTimeStamp(),
            "data" => $jti,
            "scope" => ''
        ];
    } else {
        $payload = [
            "iat" => $identified['id_user'],
            "exp" => $future->getTimeStamp(),
            "data" => $jti,
            "scope" => ''
        ];
    }

    $secret = getenv("JWT_SECRET");
    $token = JWT::encode($payload, $secret, "HS256");
    $data["status"] = "ok";
    $data["token"] = $token;

    return $response->withStatus(201)
        ->withHeader("Content-Type", "application/json")
        ->write(json_encode($data, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));
});

/* This is just for debugging, not usefull in real life. */
$app->get("/dump", function ($request, $response, $arguments) {
    print_r($this->token);
});

$app->post("/dump", function ($request, $response, $arguments) {
    print_r($this->token);
});
