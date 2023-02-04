<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Models\User;


final class AuthTlgBot
{
    public function __invoke(\Slim\Http\Request $request, \Slim\Http\Response $response, callable $next): \Slim\Http\Response
    {
        global $user;
        if ($user === null) {
            $uid = $request->getQueryParam('user');
            $user = User::find($uid);
            if ($user === null) {
                $user = new User();
                $user->isLogin = false;
            }
        }
        return $next($request, $response);
    }
}
