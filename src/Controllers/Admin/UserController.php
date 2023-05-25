<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\AuthController;
use App\Controllers\BaseController;
use App\Models\Bought;
use App\Models\Shop;
use App\Models\User;
use App\Services\Auth;
use App\Utils\Check;
use App\Utils\Cookie;
use App\Utils\Hash;
use App\Utils\Tools;
use Slim\Http\Request;
use Slim\Http\Response;

final class UserController extends BaseController
{
    public static $details = [
        'field' => [
            'op' => 'Operate',
            'id' => 'ID',
            'user_name' => 'Nickname',
            'email' => 'Email',
            'money' => 'Balance',
            'ref_by' => 'Inviter',
            'transfer_enable' => 'Flow limit',
            'last_day_t' => 'Cumulative usage',
            'class' => 'Level',
            'reg_date' => 'Registration time',
            'expire_in' => 'Account expired',
            'class_expire' => 'Level expired',
        ],
        'create_dialog' => [
            [
                'id' => 'email',
                'info' => 'Email',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'password',
                'info' => 'Password',
                'type' => 'input',
                'placeholder' => 'If the login password is left blank, it will be randomly generated',
            ],
            [
                'id' => 'ref_by',
                'info' => 'Invite people',
                'type' => 'input',
                'placeholder' => 'Inviter\'s user id, can be left blank',
            ],
            [
                'id' => 'balance',
                'info' => 'Balance',
                'type' => 'input',
                'placeholder' => '-1 is set by default, others are specified values',
            ],
        ],
    ];

    public static $update_field = [
        'email',
        'user_name',
        'remark',
        'pass',
        'money',
        'is_admin',
        'ga_enable',
        'use_new_shop',
        'is_banned',
        'banned_reason',
        'transfer_enable',
        'invite_num',
        'ref_by',
        'class_expire',
        'expire_in',
        'node_group',
        'class',
        'auto_reset_day',
        'auto_reset_bandwidth',
        'node_speedlimit',
        'node_connector',
        'port',
        'passwd',
        'method',
        'forbidden_ip',
        'forbidden_port',
    ];

    /**
     * @param array     $args
     */
    public function index(Request $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('shops', Shop::orderBy('name')->get())
                ->assign('details', self::$details)
                ->display('admin/user/index.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function createNewUser(Request $request, Response $response, array $args)
    {
        $email = $request->getParam('email');
        $ref_by = $request->getParam('ref_by');
        $password = $request->getParam('password');
        $balance = $request->getParam('balance');
        $shop_id = $request->getParam('product');

        try {
            if ($email === '') {
                throw new \Exception('Please fill in the mailbox');
            }
            if (!Check::isEmailLegal($email)) {
                throw new \Exception('The mailbox format is incorrect');
            }
            $exist = User::where('email', $email)->first();
            if ($exist !== null) {
                throw new \Exception('This mailbox is already registered');
            }
            if ($password === '') {
                $password = Tools::genRandomChar(16);
            }
            AuthController::registerHelper($response, 'user', $email, $password, '', 1, '', 0, $balance, 1, true);
            $user = User::where('email', $email)->first();
            if ($shop_id > 0) {
                $shop = Shop::find($shop_id);
                if ($shop !== null) {
                    $bought = new Bought();
                    $bought->userid = $user->id;
                    $bought->shopid = $shop->id;
                    $bought->datetime = \time();
                    $bought->renew = 0;
                    $bought->coupon = '';
                    $bought->price = $shop->price;
                    $bought->save();
                    $shop->buy($user);
                } else {
                    return $response->withJson([
                        'ret' => 0,
                        'msg' => 'Failed to add, package does not exist',
                    ]);
                }
            }
            if ($ref_by !== '') {
                $user->ref_by = (int) $ref_by;
                $user->save();
            }
        } catch (\Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'Added successfully, user email:' . $email . 'Password:' . $password,
        ]);
    }

    /**
     * @param array     $args
     */
    public function edit(Request $request, Response $response, array $args)
    {
        $user = User::find($args['id']);
        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->assign('edit_user', $user)
                ->display('admin/user/edit.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function update(Request $request, Response $response, array $args)
    {
        $id = $args['id'];
        $user = User::find($id);

        if ($request->getParam('pass') !== '' && $request->getParam('pass') !== null) {
            $user->pass = Hash::passwordHash($request->getParam('pass'));
            $user->cleanLink();
        }

        $user->addMoneyLog($request->getParam('money') - $user->money);

        $user->email = $request->getParam('email');
        $user->user_name = $request->getParam('user_name');
        $user->remark = $request->getParam('remark');
        $user->money = $request->getParam('money');
        $user->is_admin = $request->getParam('is_admin') === 'true' ? 1 : 0;
        $user->ga_enable = $request->getParam('ga_enable') === 'true' ? 1 : 0;
        $user->use_new_shop = $request->getParam('use_new_shop') === 'true' ? 1 : 0;
        $user->is_banned = $request->getParam('is_banned') === 'true' ? 1 : 0;
        $user->banned_reason = $request->getParam('banned_reason');
        $user->transfer_enable = Tools::toGB($request->getParam('transfer_enable'));
        $user->invite_num = $request->getParam('invite_num');
        $user->ref_by = $request->getParam('ref_by');
        $user->class_expire = $request->getParam('class_expire');
        $user->expire_in = $request->getParam('expire_in');
        $user->node_group = $request->getParam('node_group');
        $user->class = $request->getParam('class');
        $user->auto_reset_day = $request->getParam('auto_reset_day');
        $user->auto_reset_bandwidth = $request->getParam('auto_reset_bandwidth');
        $user->node_speedlimit = $request->getParam('node_speedlimit');
        $user->node_connector = $request->getParam('node_connector');
        $user->port = $request->getParam('port');
        $user->passwd = $request->getParam('passwd');
        $user->method = $request->getParam('method');
        $user->forbidden_ip = str_replace(PHP_EOL, ',', $request->getParam('forbidden_ip'));
        $user->forbidden_port = str_replace(PHP_EOL, ',', $request->getParam('forbidden_port'));

        if (!$user->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Modification failed',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => 'Modified successfully',
        ]);
    }
    /**
     * @param array     $args
     */
    public function delete(Request $request, Response $response, array $args)
    {
        $id = $args['id'];
        $user = User::find((int) $id);

        if (!$user->killUser()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Delete failed',
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'delete successfully',
        ]);
    }

    /**
     * @param array     $args
     */
    public function changetouser(Request $request, Response $response, array $args)
    {
        $userid = $request->getParam('userid');
        $adminid = $request->getParam('adminid');
        $user = User::find($userid);
        $admin = User::find($adminid);
        $expire_in = \time() + 60 * 60;

        if (!$admin->is_admin || !$user || !Auth::getUser()->isLogin) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Illegal request',
            ]);
        }

        Cookie::set([
            'uid' => $user->id,
            'email' => $user->email,
            'key' => Hash::cookieHash($user->pass, $expire_in),
            'ip' => md5($_SERVER['REMOTE_ADDR'] . $_ENV['key'] . $user->id . $expire_in),
            'expire_in' => $expire_in,
            'old_uid' => Cookie::get('uid'),
            'old_email' => Cookie::get('email'),
            'old_key' => Cookie::get('key'),
            'old_ip' => Cookie::get('ip'),
            'old_expire_in' => Cookie::get('expire_in'),
            'old_local' => $request->getParam('local'),
        ], $expire_in);

        return $response->withJson([
            'ret' => 1,
            'msg' => 'Switch successfully',
        ]);
    }

    /**
     * @param array     $args
     */
    public function ajax(Request $request, Response $response, array $args)
    {
        $users = User::orderBy('id', 'desc')->get();

        foreach ($users as $user) {
            $user->op = '<button type="button" class="btn btn-red" id="delete-user-' . $user->id . '" 
            onclick="deleteUser(' . $user->id . ')">Delete</button>
            <a class="btn btn-blue" href="/admin/user/' . $user->id . '/edit">Edit</a>';
            $user->transfer_enable = round($user->transfer_enable / 1073741824, 2);
            $user->last_day_t = round($user->last_day_t / 1073741824, 2);
        }

        return $response->withJson([
            'users' => $users,
        ]);
    }
}
