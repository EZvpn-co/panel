<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\User;
use App\Models\Shop;
use App\Models\Code;
use App\Models\Setting;
use App\Models\Payback;
use App\Models\Bought;
use App\Models\Coupon;
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

    public function subscription(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        if (!$user->isLogin) {
            return $response->withStatus(401);
        }

        $univSub = SubController::getUniversalSub($this->user);
        $tradSub = LinkController::getTraditionalSub($this->user);

        return $response->withJson([
            'ok' => true,
            'subscription' => [
                'json' => "{$univSub}/json",
                'clash' => "{$univSub}/clash",
                'surfboard' => "{$univSub}/surfboard",
                'ss' => "{$tradSub}?sub=2",
                'v2ray' => "{$tradSub}?sub=3",
                'trojan' => "{$tradSub}?sub=4",
            ]
        ]);
    }

    public function chargeByCode(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        if (!$user->isLogin) {
            return $response->withStatus(401);
        }

        $code = trim($request->getParam('code'));
        if ($code === '') {
            return $response->withStatus(404)->withJson([
                "ok" => false,
                "msg" => 'Please fill in the recharge code'
            ]);
        }

        $codeq = Code::where('code', $code)->where('isused', 0)->first();
        if ($codeq === null) {
            return $response->withStatus(404)->withJson([
                "ok" => false,
                "msg" => 'There is no such recharge code'
            ]);
        }

        $codeq->isused = 1;
        $codeq->usedatetime = date('Y-m-d H:i:s');
        $codeq->userid = $user->id;
        $codeq->save();

        if ($codeq->type === -1) {
            $user->money += $codeq->number;
            $user->save();

            // 返利
            if ($user->ref_by > 0 && Setting::obtain('invitation_mode') === 'after_recharge') {
                Payback::rebate($user->id, $codeq->number);
            }

            return $response->withJson([
                'ret' => 1,
                'money' => $user->money,
                'new_money' => $codeq->number,
            ]);
        }
    }

    public function shop(Request $request, Response $response, array $args)
    {
        $plan = $request->getParam('plan');
        if ($plan) {
            $shop = Shop::where('id', $plan)->get()[0];
            $shop->className = $_ENV['user_levels_name'][$shop->content['class']];
            return $response->withJson([
                'ok' => true,
                'plan' =>  $shop
            ]);
        }
        $shop = Shop::where('status', 1)->orderBy('name')->get();

        for ($i = 0; $i < count($shop); $i++) {
            $shop[$i]->className = $_ENV['user_levels_name'][$shop[$i]->content['class']];
        }
        return $response->withJson([
            'ok' => true,
            'plans' =>  $shop
        ]);
    }

    public function purchase(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        if (!$user->isLogin) {
            return $response->withStatus(401);
        }

        $shop = $request->getParam('plan');
        $coupon = trim($request->getParam('coupon'));
        $autorenew = $request->getParam('autorenew');
        $disableothers = $request->getParam('disableothers');
        $coupon_code = $coupon;

        $shop = Shop::where('id', $shop)
            ->where('status', 1)
            ->first();

        if ($shop === null) {
            return $response->withStatus(400)->withJson([
                "ok" => false,
                "msg" => 'The product does not exist or has been discontinued'
            ]);
        }

        $orders = Bought::where('userid', $user->id)->get();
        foreach ($orders as $order) {
            if ($order->shop()->useLoop()) {
                if ($order->valid()) {
                    return $response->withStatus(400)->withJson([
                        "ok" => false,
                        "msg" => 'The package you purchased with the automatic reset system has not expired, so you cannot purchase a new package'
                    ]);
                }
            }
        }

        if ($coupon === '') {
            $credit = 0;
        } else {
            $coupon = Coupon::where('code', $coupon)->first();
            if ($coupon === null) {
                return $response->withStatus(400)->withJson([
                    "ok" => false,
                    "msg" => 'This coupon code does not exist'
                ]);
            }
            $credit = $coupon->credit;
            if ($coupon->order($shop->id) === false) {
                return $response->withStatus(400)->withJson([
                    "ok" => false,
                    "msg" => 'This promo code does not apply to this item'
                ]);
            }
            if ($coupon->expire < \time()) {
                return $response->withStatus(400)->withJson([
                    "ok" => false,
                    "msg" => 'This coupon code has expired'
                ]);
            }
            if ($coupon->onetime > 0) {
                $use_count = Bought::where('userid', $user->id)
                    ->where('coupon', $coupon->code)
                    ->count();
                if ($use_count >= $coupon->onetime) {
                    return $response->withStatus(400)->withJson([
                        "ok" => false,
                        "msg" => 'This coupon code has been used the maximum number of times'
                    ]);
                }
            }
        }

        $price = $shop->price * (100 - $credit) / 100;
        if (bccomp((string) $user->money, (string) $price, 2) === -1) {
            return $response->withStatus(400)->withJson([
                "ok" => false,
                "msg" => 'The account balance is insufficient, please recharge first'
            ]);
        }
        $user->money = bcsub((string) $user->money, (string) $price, 2);
        $user->save();

        if ($disableothers === 1) {
            $boughts = Bought::where('userid', $user->id)->get();
            foreach ($boughts as $disable_bought) {
                $disable_bought->renew = 0;
                $disable_bought->save();
            }
        }

        $bought = new Bought();
        $bought->userid = $user->id;
        $bought->shopid = $shop->id;
        $bought->datetime = \time();
        if ($autorenew === 0 || $shop->auto_renew === 0) {
            $bought->renew = 0;
        } else {
            $bought->renew = \time() + $shop->auto_renew * 86400;
        }
        $bought->coupon = $coupon_code;
        $bought->price = $price;
        $bought->save();
        $shop->buy($user);


        if ($user->ref_by > 0 && Setting::obtain('invitation_mode') === 'after_purchase') {
            Payback::rebate($user->id, $price);
        }

        return ResponseHelper::successfully($response, 'Successful purchase');
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
        $password = $request->getParam('password');
        $code = trim($request->getParam('code'));
        $imtype = 1;
        $imvalue = '';

        // check email format
        $check_res = Check::isEmailLegal($email);
        if ($check_res['ret'] === 0) {
            return $response->withStatus(400)->withJson([
                'ret' => 0,
                'msg' => $check_res['msg'],
            ]);
        }

        // check email
        $user = User::where('email', $email)->first();
        if ($user !== null) {
            return $response->withStatus(400)->withJson([
                'ret' => 0,
                'msg' => 'Mailbox has been registered',
            ]);
        }

        // check pwd length
        if (strlen($password) < 8) {
            return $response->withStatus(400)->withJson([
                'ret' => 0,
                'msg' => 'The password must be greater than 8 characters',
            ]);
        }

        if (!$code) $code = "f2f3409315";

        return AuthController::registerHelper($response, $name, $email, $password, $code, $imtype, $imvalue, 0, 0, 0, false);
    }

    public function beAgent(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        if (!$user->isLogin) {
            return $response->withStatus(401);
        }

        if ($user->is_agent === 1) {
            return $response->withStatus(400)->withJson([
                "ok" => false,
                "msg" => 'You already are an agent'
            ]);
        }

        $user->is_agent = 1;
        $user->save();

        return $response->withJson([
            "ok" => true,
            "msg" => 'You are an agent'
        ]);
    }
}
