<?php

declare(strict_types=1);

namespace App\Controllers;


use Slim\Http\Request;
use Slim\Http\Response;

/*
 * Class TelegramBot
 *
 * @package App\Controllers
 */

final class TelegramBotController extends BaseController
{
    /**
     * @param array     $args
     */
    public function servers(Request $request, Response $response, array $args)
    {

        return $response->withJson([
            'ok' => true,
            'servers' => []
        ]);
    }
}
