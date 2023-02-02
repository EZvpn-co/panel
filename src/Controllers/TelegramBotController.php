<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Utils\Tools;
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
            $array_node['class'] = $_ENV['node_levels_name'][$node->node_class] || "NotSpecific";
            $array_node['type'] = Tools::getNodeType($array_node);
            $array_node['sort'] = Tools::getNodeSort($array_node);
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
}
