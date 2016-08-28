<?php
/**
 * Created by PhpStorm.
 * User: ark
 * Date: 8/27/2016
 * Time: 3:05 PM
 */

$app->get('/dpb-login[/{error}]', function ($request, $response, $arg) {
    $msg = isset($arg['error']) ? $arg['error'] : '';
    return $this->renderer->render($response, "/dpb/login/index.phtml", ['msg' => $msg]);
})->add(function ($request, $response, $next) {
    if (session('dpb-login')) {
        return $response->withStatus(302)->withHeader('Location', '/dpb/home');
    }
    $response = $next($request, $response);
    return $response;
});

$app->post('/dpb-login', function ($request, $response) {
    $requested = $request->getParsedBody();
    $usr = isset($requested['username']) ? $requested['username'] : '';
    $pwd = isset($requested['password']) ? $requested['password'] : '';
    $data = $this->db->select()->from('user')->where('username', '=', $usr)
        ->where('password', '=', md5($pwd))
        ->where('status', '=', '1')
        ->execute()->fetch();
    if (!$data) {
        return $response->withHeader('Location', '/dpb-login/Wrong combination of username and password');
    } else {
        session_set('dpb-login', $data);
        return $response->withHeader('Location', '/dpb/home');
    }
})->add(function ($request, $response, $next) {
    if (session('dpb-login')) {
        return $response->withStatus(302)->withHeader('Location', '/dpb/home');
    }
    $response = $next($request, $response);
    return $response;
});

$app->group('/dpb', function () {
    $this->get('/home', function ($request, $response) {
        $model = new \App\Home($response, $this->renderer);
        $model->getHomeDPB();
    });

    $this->get('/configuration[/{msg}]', function ($request, $response, $arg) {
        $msg = isset($arg['msg']) ? $arg['msg'] : '';
        $model = new \App\Home($response, $this->renderer);
        $model->getConfigurationDPB($msg);
    });

    $this->post('/configuration', function ($request, $response, $arg) {
        $data = $request->getParsedBody();
        $model = new \App\Home($response, $this->renderer);
        return $model->saveConfigurationDPB($data);
    });

    $this->get('/logout', function ($request, $response) {
        session_del('dpb-login');
        return $response->withStatus(302)->withHeader('Location', '/dpb-login');
    });

    $this->get('/url/remove/{id}', function ($request, $response, $arg) {
        $model = new \App\Home($response, $this->renderer);
        return $response->withJson($model->dpbUrlremove($arg['id']));
    });

    $this->post('/url/save', function ($request, $response, $arg) {
        $model = new \App\Home($response, $this->renderer);
        return $response->withJson($model->saveConfigurationDPB($request->getParsedBody()));
    });

})->add(function ($request, $response, $next) {
    if (!session('dpb-login')) {
        return $response->withStatus(302)->withHeader('Location', '/dpb-login');
    }
    $response = $next($request, $response);
    return $response;
});