<?php
/**
 * Created by PhpStorm.
 * User: ark
 * Date: 8/27/2016
 * Time: 3:05 PM
 */

$app->get('/login[/{error}]', function ($request, $response, $arg) {
    $msg = isset($arg['error']) ? $arg['error'] : '';
    return $this->renderer->render($response, "/login/index.phtml", ['msg' => $msg]);
})->add(function ($request, $response, $next) {
    if (session('login')) {
        return $response->withStatus(302)->withHeader('Location', '/smart/home');
    }
    $response = $next($request, $response);
    return $response;
});

$app->post('/login', function ($request, $response) {
    $requested = $request->getParsedBody();
    $usr = isset($requested['username']) ? $requested['username'] : '';
    $pwd = isset($requested['password']) ? $requested['password'] : '';
    $data = $this->db->select()->from('user')->where('username', '=', $usr)
        ->where('password', '=', md5($pwd))
        ->where('status', '=', '0')
        ->execute()->fetch();
    if (!$data) {
        return $response->withHeader('Location', '/login/Wrong combination of username and password');
    } else {
        session_set('login', $data);
        return $response->withHeader('Location', '/smart/home');
    }
})->add(function ($request, $response, $next) {
    if (session('login')) {
        return $response->withStatus(302)->withHeader('Location', '/smart/home');
    }
    $response = $next($request, $response);
    return $response;
});

$app->group('/smart', function () {
    $this->get('/home', function ($request, $response) {
        $model = new \App\Home($response, $this->renderer);
        $model->getHome();
    });

    $this->get('/configuration[/{msg}]', function ($request, $response, $arg) {
        $msg = isset($arg['msg']) ? $arg['msg'] : '';
        $model = new \App\Home($response, $this->renderer);
        $model->getConfiguration($msg);
    });

    $this->post('/configuration', function ($request, $response, $arg) {
        $data = $request->getParsedBody();
        $model = new \App\Home($response, $this->renderer);
        return $model->saveConfiguration($data);
    });

    $this->get('/logout', function ($request, $response) {
        session_del('login');
        return $response->withStatus(302)->withHeader('Location', '/login');
    });
})->add(function ($request, $response, $next) {
    if (!session('login')) {
        return $response->withStatus(302)->withHeader('Location', '/login');
    }
    $response = $next($request, $response);
    return $response;
});