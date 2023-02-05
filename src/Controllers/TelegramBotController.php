<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\User;
use App\Utils\Tools;
use Slim\Http\Request;
use Slim\Http\Response;
use App\Utils\Hash;
use App\Utils\Check;
use App\Utils\ResponseHelper;
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
        $user = $this->user;
        $query = Node::query();
        $query->where('type', 1)->whereNotIn('sort', [9]);
        if (!$user->is_admin) {
            $group = ($user->node_group !== 0 ? [0, $user->node_group] : [0]);
            $query->whereIn('node_group', $group);
        }
        $nodes = $query->orderBy('node_class')->orderBy('name')->get();
        $all_node = [];
        foreach ($nodes as $node) {
            $array_node = [];
            $array_node['id'] = $node->id;
            $array_node['name'] = $node->name;
            $array_node['class'] = $_ENV['node_levels_name'][$node->node_class];
            $array_node['type'] = Tools::getNodeType($node);
            $array_node['sort'] = Tools::getNodeSort($node);
            $array_node['info'] = $node->info;
            $array_node['online_user'] = $node->online_user;
            $array_node['online'] = $node->getNodeOnlineStatus();
            $array_node['traffic_rate'] = $node->traffic_rate;
            $array_node['status'] = $node->status;
            $array_node['traffic_used'] = (int) Tools::flowToGB($node->node_bandwidth);
            $array_node['traffic_limit'] = (int) Tools::flowToGB($node->node_bandwidth_limit);
            $array_node['bandwidth'] = $node->getNodeSpeedlimit();

            $all_node[] = $array_node;
        }

        return $response->withJson([
            'ok' => true,
            'servers' => $all_node
        ]);
    }


    public function account(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        if (!$user->isLogin) {
            return $response->withStatus(401);
        }

        $user->node_group = $_ENV['user_groups_name'][$user->node_group];
        $user->class = $_ENV['user_levels_name'][$user->class];
        $user->used_traffic = $user->usedTraffic();
        $user->unused_traffic = $user->unusedTraffic();
        $user->total_traffic = $user->enableTraffic();

        return $response->withJson([
            'ok' => true,
            'account' => $user
        ]);
    }


    public function login(Request $request, Response $response, array $args)
    {
        $email = strtolower(trim($request->getParam('email')));
        $password = $request->getParam('password');

        $user = User::where('email', $email)->first();
        if ($user === null) {
            return $response->withStatus(401)->withJson([
                'ret' => 0,
                'msg' => 'Email not found',
            ]);
        }

        if (!Hash::checkPassword($user->pass, $password)) {
            return $response->withStatus(401)->withJson([
                'ret' => 0,
                'msg' => 'Email or Password is invalid',
            ]);
        }

        return $response->withJson([
            'ok' => true,
            'account_id' => $user->id,
        ]);
    }

    public function register(Request $request, Response $response, array $args)
    {
        $email = strtolower(trim($request->getParam('email')));
        $name = $request->getParam('name');
        $password = $request->getParam('passwd');
        $code = trim($request->getParam('code'));
        $imtype = 1;
        $imvalue = '';

        // check email format
        $check_res = Check::isEmailLegal($email);
        if ($check_res['ret'] === 0) {
            return $response->withJson($check_res);
        }

        // check email
        $user = User::where('email', $email)->first();
        if ($user !== null) {
            return ResponseHelper::error($response, 'Mailbox has been registered');
        }

        // check pwd length
        if (strlen($password) < 8) {
            return ResponseHelper::error($response, 'The password must be greater than 8 characters');
        }

        return AuthController::registerHelper($response, $name, $email, $password, $code, $imtype, $imvalue, 0, 0, 0);
        // return $response->withJson([
        //     'ok' => true,
        //     'account_id' => $user->id,
        // ]);
    }
}
