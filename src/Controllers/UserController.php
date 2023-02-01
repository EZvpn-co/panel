<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Ann;
use App\Models\Bought;
use App\Models\Code;
use App\Models\Docs;
use App\Models\EmailVerify;
use App\Models\InviteCode;
use App\Models\Ip;
use App\Models\LoginIp;
use App\Models\Node;
use App\Models\Payback;
use App\Models\Setting;
use App\Models\StreamMedia;
use App\Models\User;
use App\Models\UserSubscribeLog;
use App\Services\Auth;
use App\Services\Captcha;
use App\Services\Config;
use App\Services\Payment;
use App\Utils\Check;
use App\Utils\Cookie;
use App\Utils\DatatablesHelper;
use App\Utils\GA;
use App\Utils\Hash;
use App\Utils\QQWry;
use App\Utils\ResponseHelper;
use App\Utils\TelegramSessionManager;
use App\Utils\Tools;
use Ramsey\Uuid\Uuid;
use Slim\Http\Request;
use Slim\Http\Response;
use voku\helper\AntiXSS;

/**
 *  HomeController
 */
final class UserController extends BaseController
{
    /**
     * @param array     $args
     */
    public function index(Request $request, Response $response, array $args)
    {
        $captcha = [];

        if (Setting::obtain('enable_checkin_captcha') === true) {
            $captcha = Captcha::generate();
        }

        $data = [
            'today_traffic_usage' => (int) $this->user->transfer_enable === 0 ? 0 : ($this->user->u + $this->user->d - $this->user->last_day_t) / $this->user->transfer_enable * 100,
            'past_traffic_usage' => (int) $this->user->transfer_enable === 0 ? 0 : $this->user->last_day_t / $this->user->transfer_enable * 100,
            'residual_flow' => (int) $this->user->transfer_enable === 0 ? 0 : ($this->user->transfer_enable - ($this->user->u + $this->user->d)) / $this->user->transfer_enable * 100,
        ];

        return $response->write(
            $this->view()
                ->assign('ann', Ann::orderBy('date', 'desc')->first())
                ->assign('getUniversalSub', SubController::getUniversalSub($this->user))
                ->assign('getTraditionalSub', LinkController::getTraditionalSub($this->user))
                ->assign('data', $data)
                ->assign('captcha', $captcha)
                ->display('user/index.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function code(Request $request, Response $response, array $args)
    {
        $pageNum = $request->getQueryParams()['page'] ?? 1;
        $codes = Code::where('type', '<>', '-2')
            ->where('userid', '=', $this->user->id)
            ->orderBy('id', 'desc')
            ->paginate(15, ['*'], 'page', $pageNum);

        $render = Tools::paginateRender($codes);

        return $response->write(
            $this->view()
                ->assign('codes', $codes)
                ->assign('payments', Payment::getPaymentsEnabled())
                ->assign('render', $render)
                ->display('user/code.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function codeCheck(Request $request, Response $response, array $args)
    {
        $time = $request->getQueryParams()['time'];
        $codes = Code::where('userid', '=', $this->user->id)
            ->where('usedatetime', '>', date('Y-m-d H:i:s', $time))
            ->first();

        if ($codes !== null && strpos($codes->code, 'Recharge') !== false) {
            return $response->withJson([
                'ret' => 1,
            ]);
        }
        return $response->withJson([
            'ret' => 0,
        ]);
    }

    /**
     * @param array     $args
     */
    public function codePost(Request $request, Response $response, array $args)
    {
        $code = trim($request->getParam('code'));
        if ($code === '') {
            return ResponseHelper::error($response, 'Please fill in the recharge code');
        }

        $codeq = Code::where('code', $code)->where('isused', 0)->first();
        if ($codeq === null) {
            return ResponseHelper::error($response, 'There is no such recharge code');
        }

        $user = $this->user;
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
                'msg' => 'Exchange successful, the amount is ' . $codeq->number . '$',
            ]);
        }

        if ($codeq->type === 10001) {
            $user->transfer_enable += $codeq->number * 1024 * 1024 * 1024;
            $user->save();
        }

        if ($codeq->type === 10002) {
            if (\time() > strtotime($user->expire_in)) {
                $user->expire_in = date('Y-m-d H:i:s', \time() + (int) $codeq->number * 86400);
            } else {
                $user->expire_in = date('Y-m-d H:i:s', strtotime($user->expire_in) + (int) $codeq->number * 86400);
            }
            $user->save();
        }

        if ($codeq->type >= 1 && $codeq->type <= 10000) {
            if ($user->class === 0 || $user->class !== $codeq->type) {
                $user->class_expire = date('Y-m-d H:i:s', \time());
                $user->save();
            }
            $user->class_expire = date('Y-m-d H:i:s', strtotime($user->class_expire) + (int) $codeq->number * 86400);
            $user->class = $codeq->type;
            $user->save();
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => '',
        ]);
    }

    /**
     * @param array     $args
     */
    public function checkGa(Request $request, Response $response, array $args)
    {
        $code = $request->getParam('code');
        if ($code === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'QR code cannot be empty',
            ]);
        }
        $user = $this->user;
        $ga = new GA();
        $rcode = $ga->verifyCode($user->ga_token, $code);
        if (!$rcode) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'test error',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => 'test was successful',
        ]);
    }

    /**
     * @param array     $args
     */
    public function setGa(Request $request, Response $response, array $args)
    {
        $enable = $request->getParam('enable');
        if ($enable === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid option',
            ]);
        }
        $user = $this->user;
        $user->ga_enable = $enable;
        $user->save();
        return $response->withJson([
            'ret' => 1,
            'msg' => 'Successfully set',
        ]);
    }

    /**
     * @param array     $args
     */
    public function resetPort(Request $request, Response $response, array $args)
    {
        $temp = $this->user->resetPort();
        return $response->withJson([
            'ret' => ($temp['ok'] === true ? 1 : 0),
            'msg' => $temp['msg'],
        ]);
    }

    /**
     * @param array     $args
     */
    public function specifyPort(Request $request, Response $response, array $args)
    {
        $temp = $this->user->specifyPort((int) $request->getParam('port'));
        return $response->withJson([
            'ret' => ($temp['ok'] === true ? 1 : 0),
            'msg' => $temp['msg'],
        ]);
    }

    /**
     * @param array     $args
     */
    public function resetGa(Request $request, Response $response, array $args)
    {
        $ga = new GA();
        $secret = $ga->createSecret();
        $user = $this->user;
        $user->ga_token = $secret;
        $user->save();
        return $response->withStatus(302)->withHeader('Location', '/user/edit');
    }

    /**
     * @param array     $args
     */
    public function profile(Request $request, Response $response, array $args)
    {
        $pageNum = $request->getQueryParams()['page'] ?? 1;
        $paybacks = Payback::where('ref_by', $this->user->id)
            ->orderBy('datetime', 'desc')
            ->paginate(15, ['*'], 'page', $pageNum);

        // login IP
        $totallogin = LoginIp::where('userid', '=', $this->user->id)->where('type', '=', 0)->orderBy('datetime', 'desc')->take(10)->get();

        // use IP
        $userip = [];
        $iplocation = new QQWry();
        $total = Ip::where('datetime', '>=', \time() - 300)->where('userid', '=', $this->user->id)->get();
        foreach ($total as $single) {
            $single->ip = Tools::getRealIp($single->ip);
            $is_node = Node::where('node_ip', $single->ip)->first();
            if ($is_node) {
                continue;
            }
            if (!isset($userip[$single->ip])) {
                $location = $iplocation->getlocation($single->ip);
                $userip[$single->ip] = iconv('gbk', 'utf-8//IGNORE', $location['country'] . $location['area']);
            }
        }

        if ($request->getParam('json') === 1) {
            return $response->withJson([
                'ret' => 1,
                'paybacks' => $paybacks,
                'userloginip' => $totallogin,
                'userip' => $userip,
            ]);
        }

        $boughts = Bought::where('userid', $this->user->id)->orderBy('id', 'desc')->get();

        return $response->write(
            $this->view()
                ->assign('boughts', $boughts)
                ->assign('userip', $userip)
                ->assign('userloginip', $totallogin)
                ->assign('paybacks', $paybacks)
                ->registerClass('Tools', Tools::class)
                ->display('user/profile.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function announcement(Request $request, Response $response, array $args)
    {
        $Anns = Ann::orderBy('date', 'desc')->get();

        if ($request->getParam('json') === 1) {
            return $response->withJson([
                'Anns' => $Anns,
                'ret' => 1,
            ]);
        }

        return $response->write(
            $this->view()
                ->assign('anns', $Anns)
                ->display('user/announcement.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function docs(Request $request, Response $response, array $args)
    {
        $docs = Docs::orderBy('id', 'desc')->get();

        if ($request->getParam('json') === 1) {
            return $response->withJson([
                'docs' => $docs,
                'ret' => 1,
            ]);
        }

        return $response->write(
            $this->view()
                ->assign('docs', $docs)
                ->display('user/docs.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function media(Request $request, Response $response, array $args)
    {
        $results = [];
        $db = new DatatablesHelper();
        $nodes = $db->query('SELECT DISTINCT node_id FROM stream_media');

        foreach ($nodes as $node_id) {
            $node = Node::where('id', $node_id)->first();

            $unlock = StreamMedia::where('node_id', $node_id)
                ->orderBy('id', 'desc')
                ->where('created_at', '>', \time() - 86460) // Only get the data reported within the last day and one minute
                ->first();

            if ($unlock !== null && $node !== null) {
                $details = \json_decode($unlock->result, true);
                // $details = str_replace('Originals Only', '仅限自制', $details);
                // $details = str_replace('Oversea Only', '仅限海外', $details);

                foreach ($details as $key => $value) {
                    $info = [
                        'node_name' => $node->name,
                        'created_at' => $unlock->created_at,
                        'unlock_item' => $details,
                    ];
                }

                array_push($results, $info);
            }
        }

        if ($_ENV['streaming_media_unlock_multiplexing'] !== null) {
            foreach ($_ENV['streaming_media_unlock_multiplexing'] as $key => $value) {
                $key_node = Node::where('id', $key)->first();
                $value_node = StreamMedia::where('node_id', $value)
                    ->orderBy('id', 'desc')
                    ->where('created_at', '>', \time() - 86460) // Only get the data reported within the last day and one minute
                    ->first();

                if ($value_node !== null) {
                    $details = \json_decode($value_node->result, true);
                    // $details = str_replace('Originals Only', '仅限自制', $details);
                    // $details = str_replace('Oversea Only', '仅限海外', $details);

                    $info = [
                        'node_name' => $key_node->name,
                        'created_at' => $value_node->created_at,
                        'unlock_item' => $details,
                    ];

                    array_push($results, $info);
                }
            }
        }

        $node_names = array_column($results, 'node_name');
        array_multisort($node_names, SORT_ASC, $results);

        return $this->view()
            ->assign('results', $results)
            ->display('user/media.tpl');
    }

    /**
     * @param array     $args
     */
    public function edit(Request $request, Response $response, array $args)
    {
        $themes = Tools::getDir(BASE_PATH . '/resources/views');
        $bind_token = TelegramSessionManager::addBindSession($this->user);
        $methods = Config::getSupportParam('method');

        return $this->view()
            ->assign('user', $this->user)
            ->assign('themes', $themes)
            ->assign('bind_token', $bind_token)
            ->assign('methods', $methods)
            ->assign('telegram_bot', $_ENV['telegram_bot'])
            ->registerClass('Config', Config::class)
            ->display('user/edit.tpl');
    }

    /**
     * @param array     $args
     */
    public function invite(Request $request, Response $response, array $args)
    {
        $code = InviteCode::where('user_id', $this->user->id)->first();
        if ($code === null) {
            $this->user->addInviteCode();
            $code = InviteCode::where('user_id', $this->user->id)->first();
        }

        $pageNum = $request->getQueryParams()['page'] ?? 1;

        $paybacks = Payback::where('ref_by', $this->user->id)
            ->orderBy('id', 'desc')
            ->paginate(15, ['*'], 'page', $pageNum);

        $paybacks_sum = Payback::where('ref_by', $this->user->id)->sum('ref_get');
        if (!$paybacks_sum) {
            $paybacks_sum = 0;
        }

        $render = Tools::paginateRender($paybacks);

        $invite_url = $_ENV['baseUrl'] . '/auth/register?code=' . $code->code;

        return $this->view()
            ->assign('code', $code)
            ->assign('render', $render)
            ->assign('paybacks', $paybacks)
            ->assign('invite_url', $invite_url)
            ->assign('paybacks_sum', $paybacks_sum)
            ->display('user/invite.tpl');
    }

    /**
     * @param array     $args
     */
    public function buyInvite(Request $request, Response $response, array $args)
    {
        $price = Setting::obtain('invite_price');
        $num = $request->getParam('num');
        $num = trim($num);

        if (!Tools::isInt($num) || $price < 0 || $num <= 0) {
            return ResponseHelper::error($response, 'Illegal request');
        }

        $amount = $price * $num;

        $user = $this->user;

        if (!$user->isLogin) {
            return $response->withJson(['ret' => -1]);
        }

        if ($user->money < $amount) {
            return ResponseHelper::error($response, 'Insufficient balance, total price of' . $amount . '$');
        }
        $user->invite_num += $num;
        $user->money -= $amount;
        $user->save();

        return ResponseHelper::successfully($response, 'Invitations added successfully');
    }

    /**
     * @param array     $args
     */
    public function customInvite(Request $request, Response $response, array $args)
    {
        $price = Setting::obtain('custom_invite_price');
        $customcode = $request->getParam('customcode');
        $customcode = trim($customcode);

        if (Tools::isSpecialChars($customcode) || $price < 0 || $customcode === '' || strlen($customcode) > 32) {
            return ResponseHelper::error(
                $response,
                'Customization failed, the invitation link cannot be empty, the suffix cannot contain special symbols and the length cannot exceed 32 characters'
            );
        }

        if (InviteCode::where('code', $customcode)->count() !== 0) {
            return ResponseHelper::error($response, 'This suffix has been registered');
        }

        $user = $this->user;

        if (!$user->isLogin) {
            return $response->withJson(['ret' => -1]);
        }

        if ($user->money < $price) {
            return ResponseHelper::error(
                $response,
                'Insufficient balance, total price of' . $price . '$'
            );
        }
        $code = InviteCode::where('user_id', $user->id)->first();
        $code->code = $customcode;
        $user->money -= $price;
        $user->save();
        $code->save();
        return ResponseHelper::successfully($response, 'Customized successfully');
    }

    /**
     * @param array     $args
     */
    public function updatePassword(Request $request, Response $response, array $args)
    {
        $oldpwd = $request->getParam('oldpwd');
        $pwd = $request->getParam('pwd');
        $repwd = $request->getParam('repwd');
        $user = $this->user;
        if (!Hash::checkPassword($user->pass, $oldpwd)) {
            return ResponseHelper::error($response, 'The old password is wrong');
        }
        if ($pwd !== $repwd) {
            return ResponseHelper::error($response, 'The two inputs do not match');
        }

        if (strlen($pwd) < 8) {
            return ResponseHelper::error($response, 'The password is too short');
        }
        $hashPwd = Hash::passwordHash($pwd);
        $user->pass = $hashPwd;
        $user->save();

        if ($_ENV['enable_forced_replacement'] === true) {
            $user->cleanLink();
        }

        return ResponseHelper::successfully($response, 'Successfully modified');
    }

    /**
     * @param array     $args
     */
    public function updateEmail(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        $newemail = $request->getParam('newemail');
        $oldemail = $user->email;
        $otheruser = User::where('email', $newemail)->first();

        if ($_ENV['enable_change_email'] !== true) {
            return ResponseHelper::error($response, 'This item is not allowed to be modified by yourself, please contact the administrator for operation');
        }

        if (Setting::obtain('reg_email_verify')) {
            $emailcode = $request->getParam('emailcode');
            $mailcount = EmailVerify::where('email', '=', $newemail)->where('code', '=', $emailcode)->where('expire_in', '>', \time())->first();
            if ($mailcount === null) {
                return ResponseHelper::error($response, 'Your email verification code is incorrect');
            }
        }

        if ($newemail === '') {
            return ResponseHelper::error($response, 'Email address not filled');
        }

        $check_res = Check::isEmailLegal($newemail);
        if ($check_res['ret'] === 0) {
            return $response->withJson($check_res);
        }

        if ($otheruser !== null) {
            return ResponseHelper::error($response, 'Email is already in use');
        }

        if ($newemail === $oldemail) {
            return ResponseHelper::error($response, 'The new mailbox cannot be the same as the old mailbox');
        }

        $antiXss = new AntiXSS();
        $user->email = $antiXss->xss_clean($newemail);
        $user->save();

        return ResponseHelper::successfully($response, 'Successfully modified');
    }

    /**
     * @param array     $args
     */
    public function updateUsername(Request $request, Response $response, array $args)
    {
        $newusername = $request->getParam('newusername');
        $user = $this->user;
        $antiXss = new AntiXSS();
        $user->user_name = $antiXss->xss_clean($newusername);
        $user->save();

        return ResponseHelper::successfully($response, 'Successfully modified');
    }

    /**
     * @param array     $args
     */
    public function bought(Request $request, Response $response, array $args)
    {
        $pageNum = $request->getQueryParams()['page'] ?? 1;
        $shops = Bought::where('userid', $this->user->id)->orderBy('id', 'desc')->paginate(15, ['*'], 'page', $pageNum);
        if ($request->getParam('json') === 1) {
            foreach ($shops as $shop) {
                $shop->datetime = $shop->datetime();
                $shop->name = $shop->shop()->name;
                $shop->content = $shop->shop()->content();
            }
            return $response->withJson([
                'ret' => 1,
                'shops' => $shops,
            ]);
        }
        $render = Tools::paginateRender($shops);
        return $this->view()
            ->assign('shops', $shops)
            ->assign('render', $render)
            ->display('user/bought.tpl');
    }

    /**
     * @param array     $args
     */
    public function deleteBoughtGet(Request $request, Response $response, array $args)
    {
        $id = $request->getParam('id');
        $shop = Bought::where('id', $id)->where('userid', $this->user->id)->first();

        if ($shop === null) {
            return ResponseHelper::error($response, 'Failed to turn off automatic renewal, the order does not exist.');
        }

        if ($this->user->id === $shop->userid) {
            $shop->renew = 0;
        }

        if (!$shop->save()) {
            return ResponseHelper::error($response, 'Failed to turn off auto-renewal');
        }
        return ResponseHelper::successfully($response, 'Turn off automatic renewal successfully');
    }

    /**
     * @param array     $args
     */
    public function updateContact(Request $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();

        $type = $antiXss->xss_clean($request->getParam('imtype'));
        $value = $antiXss->xss_clean($request->getParam('imvalue'));

        $user = $this->user;

        if ($user->telegram_id !== null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Your account is bound Telegram , so this item cannot be modified',
            ]);
        }

        if ($value === '' || $type === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Contact information cannot be empty',
            ]);
        }

        $user_exist = User::where('im_value', $value)->where('im_type', $type)->first();
        if ($user_exist !== null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'This contact has already been registered',
            ]);
        }

        $user->im_type = $type;
        $user->im_value = $value;
        $user->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'Successfully modified',
        ]);
    }

    /**
     * @param array     $args
     */
    public function updateTheme(Request $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();
        $theme = $antiXss->xss_clean($request->getParam('theme'));

        $user = $this->user;

        if ($theme === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Theme cannot be empty',
            ]);
        }

        $user->theme = $theme;
        $user->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'Successfully modified',
        ]);
    }

    /**
     * @param array     $args
     */
    public function updateMail(Request $request, Response $response, array $args)
    {
        $value = (int) $request->getParam('mail');
        if (\in_array($value, [0, 1, 2])) {
            $user = $this->user;
            if ($value === 2 && $_ENV['enable_telegram'] === false) {
                return ResponseHelper::error(
                    $response,
                    'Modification failed, currently unavailable Telegram receive daily reports'
                );
            }
            $user->sendDailyMail = $value;
            $user->save();
            return ResponseHelper::successfully($response, 'Successfully modified');
        }
        return ResponseHelper::error($response, 'Illegal input');
    }

    /**
     * @param array     $args
     */
    public function resetPasswd(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        $pwd = Tools::genRandomChar(16);
        $current_timestamp = \time();
        $new_uuid = Uuid::uuid3(Uuid::NAMESPACE_DNS, $user->email . '|' . $current_timestamp);
        $existing_uuid = User::where('uuid', $new_uuid)->first();

        if ($existing_uuid !== null) {
            return ResponseHelper::error($response, 'There are some problems right now, please try again later');
        }

        $user->uuid = $new_uuid;
        $user->passwd = $pwd;
        $user->save();

        return ResponseHelper::successfully($response, 'Successfully modified');
    }

    /**
     * @param array     $args
     */
    public function updateMethod(Request $request, Response $response, array $args)
    {
        $user = $this->user;

        $antiXss = new AntiXSS();

        $method = strtolower($antiXss->xss_clean($request->getParam('method')));

        if ($method === '') {
            ResponseHelper::error($response, 'Illegal input');
        }
        if (!Tools::isParamValidate('method', $method)) {
            ResponseHelper::error($response, 'Invalid encryption');
        }

        $user->method = $method;
        $user->save();

        return ResponseHelper::successfully($response, 'Successfully modified');
    }

    /**
     * @param array     $args
     */
    public function logout(Request $request, Response $response, array $args)
    {
        Auth::logout();
        return $response->withStatus(302)->withHeader('Location', '/');
    }

    /**
     * @param array     $args
     */
    public function doCheckIn(Request $request, Response $response, array $args)
    {
        if ($_ENV['enable_checkin'] === false) {
            return ResponseHelper::error($response, 'Check-in is disabled');
        }

        if (Setting::obtain('enable_checkin_captcha') === true) {
            $ret = Captcha::verify($request->getParams());
            if (!$ret) {
                return ResponseHelper::error($response, 'The system cannot accept your verification result, please refresh the page and try again');
            }
        }

        if (strtotime($this->user->expire_in) < \time()) {
            return ResponseHelper::error($response, 'Only accounts that have not expired can sign in');
        }

        $checkin = $this->user->checkin();
        if ($checkin['ok'] === false) {
            return ResponseHelper::error($response, $checkin['msg']);
        }

        return $response->withJson([
            'ret' => 1,
            'trafficInfo' => [
                'todayUsedTraffic' => $this->user->todayUsedTraffic(),
                'lastUsedTraffic' => $this->user->lastUsedTraffic(),
                'unUsedTraffic' => $this->user->unusedTraffic(),
            ],
            'traffic' => Tools::flowAutoShow($this->user->transfer_enable),
            'unflowtraffic' => $this->user->transfer_enable,
            'msg' => $checkin['msg'],
        ]);
    }

    /**
     * @param array     $args
     */
    public function kill(Request $request, Response $response, array $args)
    {
        return $this->view()->display('user/kill.tpl');
    }

    /**
     * @param array     $args
     */
    public function handleKill(Request $request, Response $response, array $args)
    {
        $user = $this->user;

        $passwd = $request->getParam('passwd');
        if (!Hash::checkPassword($user->pass, $passwd)) {
            return ResponseHelper::error($response, 'password error');
        }

        if ($_ENV['enable_kill'] === true) {
            Auth::logout();
            $user->killUser();
            return ResponseHelper::successfully($response, 'Your account has been deleted from our system. Hope to visit next time');
        }
        return ResponseHelper::error($response, 'The administrator does not allow deletion, please contact the administrator if you need to delete.');
    }

    /**
     * @param array     $args
     */
    public function banned(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        return $this->view()
            ->assign('banned_reason', $user->banned_reason)
            ->display('user/banned.tpl');
    }

    /**
     * @param array     $args
     */
    public function resetTelegram(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        $user->telegramReset();

        return ResponseHelper::successfully($response, 'Reset successfully');
    }

    /**
     * @param array $args
     */
    public function resetURL(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        $user->cleanLink();

        return ResponseHelper::successfully($response, 'Reset successfully');
    }

    /**
     * @param array     $args
     */
    public function resetInviteURL(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        $user->clearInviteCodes();

        return ResponseHelper::successfully($response, 'Reset successfully');
    }

    /**
     * @param array     $args
     */
    public function backtoadmin(Request $request, Response $response, array $args)
    {
        $userid = Cookie::get('uid');
        $adminid = Cookie::get('old_uid');
        $user = User::find($userid);
        $admin = User::find($adminid);

        if (!$admin->is_admin || !$user) {
            Cookie::set([
                'uid' => null,
                'email' => null,
                'key' => null,
                'ip' => null,
                'expire_in' => null,
                'old_uid' => null,
                'old_email' => null,
                'old_key' => null,
                'old_ip' => null,
                'old_expire_in' => null,
                'old_local' => null,
            ], \time() - 1000);
        }
        $expire_in = Cookie::get('old_expire_in');
        $local = Cookie::get('old_local');
        Cookie::set([
            'uid' => Cookie::get('old_uid'),
            'email' => Cookie::get('old_email'),
            'key' => Cookie::get('old_key'),
            'ip' => Cookie::get('old_ip'),
            'expire_in' => $expire_in,
            'old_uid' => null,
            'old_email' => null,
            'old_key' => null,
            'old_ip' => null,
            'old_expire_in' => null,
            'old_local' => null,
        ], $expire_in);
        return $response->withStatus(302)->withHeader('Location', $local);
    }

    /**
     * 订阅记录
     *
     * @param array    $args
     */
    public function subscribeLog(Request $request, Response $response, array $args)
    {
        if ($_ENV['subscribeLog_show'] === false) {
            return $response->withStatus(302)->withHeader('Location', '/user');
        }

        $pageNum = $request->getQueryParams()['page'] ?? 1;
        $logs = UserSubscribeLog::orderBy('id', 'desc')->where('user_id', $this->user->id)->paginate(15, ['*'], 'page', $pageNum);

        $render = Tools::paginateRender($logs);
        return $this->view()
            ->assign('logs', $logs)
            ->assign('render', $render)
            ->registerClass('Tools', Tools::class)
            ->fetch('user/subscribe_log.tpl');
    }

    /**
     * @param array     $args
     */
    public function switchThemeMode(Request $request, Response $response, array $args)
    {
        $user = $this->user;
        if ($user->is_dark_mode === 1) {
            $user->is_dark_mode = 0;
        } else {
            $user->is_dark_mode = 1;
        }
        $user->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'Switch successfully',
        ]);
    }
}
