<?php

declare(strict_types=1);

namespace App\Models;

use App\Services\Mail;
use App\Utils\GA;
use App\Utils\Hash;
use App\Utils\Telegram;
use App\Utils\Tools;
use Exception;
use Ramsey\Uuid\Uuid;

/**
 * User Model
 *
 * @property-read   int     $id         ID
 *
 * @todo More property
 *
 * @property        bool    $is_admin           Are you an administrator
 * @property        bool    $expire_notified    If user is notified for expire
 * @property        bool    $traffic_notified   If user is noticed for low traffic
 */
final class User extends Model
{
    /**
     * logged
     *
     * @var bool
     */
    public $isLogin;
    protected $connection = 'default';

    protected $table = 'user';

    /**
     * cast
     *
     * @var array
     */
    protected $casts = [
        'port' => 'int',
        'is_admin' => 'boolean',
        'node_speedlimit' => 'float',
        'sendDailyMail' => 'int',
        'ref_by' => 'int',
    ];

    /**
     * Gravatar Avatar address
     */
    public function getGravatarAttribute(): string
    {
        $hash = md5(strtolower(trim($this->email)));
        return 'https://www.gravatar.com/avatar/' . $hash . '?&d=identicon';
    }

    /**
     * Contact type
     */
    public function imType(): string
    {
        switch ($this->im_type) {
            case 1:
                return 'WeChat';
            case 2:
                return 'QQ';
            case 5:
                return 'Discord';
            default:
                return 'Telegram';
        }
    }

    /**
     * Contact information
     */
    public function imValue(): string
    {
        switch ($this->im_type) {
            case 1:
            case 2:
            case 5:
                return $this->im_value;
            default:
                return '<a href="https://telegram.me/' . $this->im_value . '">' . $this->im_value . '</a>';
        }
    }

    /**
     * last used time
     */
    public function lastSsTime(): string
    {
        return $this->t === 0 || $this->t === null ? 'Never used meow' : Tools::toDateTime($this->t);
    }

    /**
     * Last check-in time
     */
    public function lastCheckInTime(): string
    {
        return $this->last_check_in_time === 0 ? 'Never checked in' : Tools::toDateTime($this->last_check_in_time);
    }

    /**
     * Update password
     */
    public function updatePassword(string $pwd): bool
    {
        $this->pass = Hash::passwordHash($pwd);
        return $this->save();
    }

    public function getForbiddenIp()
    {
        return str_replace(',', PHP_EOL, $this->forbidden_ip);
    }

    public function getForbiddenPort()
    {
        return str_replace(',', PHP_EOL, $this->forbidden_port);
    }

    /**
     * Generate invitation code
     */
    public function addInviteCode(): string
    {
        while (true) {
            $temp_code = Tools::genRandomChar(10);
            if (InviteCode::where('code', $temp_code)->first() === null) {
                if (InviteCode::where('user_id', $this->id)->count() === 0) {
                    $code = new InviteCode();
                    $code->code = $temp_code;
                    $code->user_id = $this->id;
                    $code->save();
                    return $temp_code;
                }
                return InviteCode::where('user_id', $this->id)->first()->code;
            }
        }
    }

    /**
     * Add invites
     */
    public function addInviteNum(int $num): bool
    {
        $this->invite_num += $num;
        return $this->save();
    }

    /**
     * generate new UUID
     */
    public function generateUUID($s): bool
    {
        $this->uuid = Uuid::uuid3(
            Uuid::NAMESPACE_DNS,
            $this->email . '|' . $s
        );
        return $this->save();
    }

    /**
     * generate new API Token
     */
    public function generateApiToken($s): bool
    {
        $this->api_token = Uuid::uuid3(
            Uuid::NAMESPACE_DNS,
            $this->pass . '|' . $s
        );
        return $this->save();
    }

    /*
     * Total flow [automatic unit]
     */
    public function enableTraffic(): string
    {
        return Tools::flowAutoShow($this->transfer_enable);
    }

    /*
     * Total traffic [GB], without unit
     */
    public function enableTrafficInGB(): float
    {
        return Tools::flowToGB($this->transfer_enable);
    }

    /*
     * Flow used [automatic unit]
     */
    public function usedTraffic(): string
    {
        return Tools::flowAutoShow($this->u + $this->d);
    }

    /*
     * Used traffic as a percentage of total traffic
     */
    public function trafficUsagePercent(): int
    {
        if ($this->transfer_enable === 0) {
            return 0;
        }
        $percent = ($this->u + $this->d) / $this->transfer_enable;
        $percent = round($percent, 2);
        return (int) $percent * 100;
    }

    /*
     * Residual flow [automatic unit]
     */
    public function unusedTraffic(): string
    {
        return Tools::flowAutoShow($this->transfer_enable - ($this->u + $this->d));
    }

    /*
     * Percentage of remaining flow to total flow
     */
    public function unusedTrafficPercent(): float
    {
        if ($this->transfer_enable === 0) {
            return 0;
        }
        $unused = $this->transfer_enable - ($this->u + $this->d);
        $percent = $unused / $this->transfer_enable;
        $percent = round($percent, 4);
        return $percent * 100;
    }

    /*
     * Traffic used today [automatic unit]
     */
    public function todayUsedTraffic(): string
    {
        return Tools::flowAutoShow($this->u + $this->d - $this->last_day_t);
    }

    /*
     * Traffic used today as a percentage of total traffic
     */
    public function todayUsedTrafficPercent(): float
    {
        if ($this->transfer_enable === 0 || $this->transfer_enable === '0' || $this->transfer_enable === null) {
            return 0;
        }
        $Todayused = $this->u + $this->d - $this->last_day_t;
        $percent = $Todayused / $this->transfer_enable;
        $percent = round($percent, 4);
        return $percent * 100;
    }

    /*
     * Traffic used before today [auto unit]
     */
    public function lastUsedTraffic(): string
    {
        return Tools::flowAutoShow($this->last_day_t);
    }

    /*
     * Percentage of total traffic used before today
     */
    public function lastUsedTrafficPercent(): float
    {
        if ($this->transfer_enable === 0 || $this->transfer_enable === '0' || $this->transfer_enable === null) {
            return 0;
        }
        $Lastused = $this->last_day_t;
        $percent = $Lastused / $this->transfer_enable;
        $percent = round($percent, 4);
        return $percent * 100;
    }

    /*
     * Is it possible to sign in
     */
    public function isAbleToCheckin(): bool
    {
        return date('Ymd') !== date('Ymd', $this->last_check_in_time);
    }

    public function getGAurl()
    {
        $ga = new GA();
        return $ga->getUrl(
            urlencode($_ENV['appName'] . '-' . $this->user_name . '-2-step verification code'),
            $this->ga_token
        );
    }

    /**
     * Get the user's invitation code
     */
    public function getInviteCodes(): ?InviteCode
    {
        return InviteCode::where('user_id', $this->id)->first();
    }

    /**
     * User's inviter
     */
    public function refByUser(): ?User
    {
        return self::find($this->ref_by);
    }

    /**
     * The username of the user inviter
     */
    public function refByUserName(): string
    {
        if ($this->ref_by === 0) {
            return 'System invitation';
        }

        $refUser = $this->refByUser();

        if ($refUser === null) {
            return 'The inviter has been removed';
        }
        return $refUser->user_name;
    }

    /**
     * Delete user's subscription link
     */
    public function cleanLink(): void
    {
        Link::where('userid', $this->id)->delete();
    }

    /**
     * Get user's subscription link
     */
    public function getSublink()
    {
        return Tools::generateSSRSubCode($this->id);
    }

    /**
     * Delete user's invitation code
     */
    public function clearInviteCodes(): void
    {
        InviteCode::where('user_id', $this->id)->delete();
    }

    /**
     * Number of online IPs
     */
    public function onlineIpCount(): int
    {
        // Deduplication based on IP grouping
        $total = Ip::where('datetime', '>=', \time() - 90)->where('userid', $this->id)->orderBy('userid', 'desc')->groupBy('ip')->get();
        $ip_list = [];
        foreach ($total as $single_record) {
            $ip = Tools::getRealIp($single_record->ip);
            if (Node::where('node_ip', $ip)->first() !== null) {
                continue;
            }
            $ip_list[] = $ip;
        }
        return count($ip_list);
    }

    /**
     * Cancel account
     */
    public function killUser(): bool
    {
        $uid = $this->id;
        $email = $this->email;

        Bought::where('userid', '=', $uid)->delete();
        Code::where('userid', '=', $uid)->delete();
        DetectBanLog::where('user_id', '=', $uid)->delete();
        DetectLog::where('user_id', '=', $uid)->delete();
        EmailVerify::where('email', $email)->delete();
        InviteCode::where('user_id', '=', $uid)->delete();
        Ip::where('userid', '=', $uid)->delete();
        Link::where('userid', '=', $uid)->delete();
        LoginIp::where('userid', '=', $uid)->delete();
        PasswordReset::where('email', '=', $email)->delete();
        TelegramSession::where('user_id', '=', $uid)->delete();
        Token::where('user_id', '=', $uid)->delete();
        UserSubscribeLog::where('user_id', '=', $uid)->delete();

        $this->delete();

        return true;
    }

    /**
     * Cumulative recharge amount
     */
    public function getTopUp(): float
    {
        $number = Code::where('userid', $this->id)->sum('number');
        return is_null($number) ? 0.00 : round((float) $number, 2);
    }

    /**
     * Get accumulated income
     */
    public function calIncome(string $req): float
    {
        switch ($req) {
            case 'yesterday':
                $number = Code::whereDate('usedatetime', '=', date('Y-m-d', strtotime('-1 days')))->sum('number');
                break;
            case 'today':
                $number = Code::whereDate('usedatetime', '=', date('Y-m-d'))->sum('number');
                break;
            case 'this month':
                $number = Code::whereYear('usedatetime', '=', date('Y'))->whereMonth('usedatetime', '=', date('m'))->sum('number');
                break;
            case 'last month':
                $number = Code::whereYear('usedatetime', '=', date('Y'))->whereMonth('usedatetime', '=', date('m', strtotime('last month')))->sum('number');
                break;
            default:
                $number = Code::sum('number');
                break;
        }
        return is_null($number) ? 0.00 : round(floatval($number), 2);
    }

    /**
     * Get the total number of paid users
     */
    public function paidUserCount(): int
    {
        return self::where('class', '!=', '0')->count();
    }

    /**
     * Get the reason why a user was banned
     */
    public function disableReason(): string
    {
        $reason_id = DetectLog::where('user_id', $this->id)->orderBy('id', 'DESC')->first();
        $reason = DetectRule::find($reason_id->list_id);
        if (is_null($reason)) {
            return 'Disabled for special reasons, please contact the administrator for details';
        }
        return $reason->text;
    }

    /**
     * Time of last ban
     */
    public function lastDetectBanTime(): string
    {
        return $this->last_detect_ban_time === '1989-06-04 00:05:00' ? 'Not banned' : $this->last_detect_ban_time;
    }

    /**
     * Current unblocking time
     */
    public function relieveTime(): string
    {
        $logs = DetectBanLog::where('user_id', $this->id)->orderBy('id', 'desc')->first();
        if ($this->enable === 0 && $logs !== null) {
            $time = $logs->end_time + $logs->ban_time * 60;
            return date('Y-m-d H:i:s', $time);
        }
        return 'currently not banned';
    }

    /**
     * Cumulative number of bans
     */
    public function detectBanNumber(): int
    {
        return DetectBanLog::where('user_id', $this->id)->count();
    }

    /**
     * Number of violations for the last ban
     */
    public function userDetectBanNumber(): int
    {
        $logs = DetectBanLog::where('user_id', $this->id)->orderBy('id', 'desc')->first();
        return $logs->detect_number;
    }

    /**
     * sign in
     */
    public function checkin(): array
    {
        $return = [
            'ok' => true,
            'msg' => '',
        ];
        if (!$this->isAbleToCheckin()) {
            $return['ok'] = false;
            $return['msg'] = 'You seem to have signed in...';
        } else {
            $traffic = random_int((int) $_ENV['checkinMin'], (int) $_ENV['checkinMax']);
            $this->transfer_enable += Tools::toMB($traffic);
            $this->last_check_in_time = \time();
            $this->save();
            $return['msg'] = 'Got' . $traffic . 'MB flow.';
        }

        return $return;
    }

    /**
     * Unbind Telegram
     */
    public function telegramReset(): array
    {
        $return = [
            'ok' => true,
            'msg' => 'Unbind successfully.',
        ];
        $telegram_id = $this->telegram_id;
        $this->telegram_id = 0;
        if ($this->save()) {
            if (
                $_ENV['enable_telegram'] === true
                &&
                Setting::obtain('telegram_group_bound_user') === true
                &&
                Setting::obtain('telegram_unbind_kick_member') === true
                &&
                !$this->is_admin
            ) {
                \App\Utils\Telegram\TelegramTools::SendPost(
                    'kickChatMember',
                    [
                        'chat_id' => $_ENV['telegram_chatid'],
                        'user_id' => $telegram_id,
                    ]
                );
            }
        } else {
            $return = [
                'ok' => false,
                'msg' => 'Failed to unbind.',
            ];
        }

        return $return;
    }

    /**
     * update port
     */
    public function setPort(int $Port): array
    {
        $PortOccupied = User::pluck('port')->toArray();
        if (\in_array($Port, $PortOccupied) === true) {
            return [
                'ok' => false,
                'msg' => 'The port is occupied',
            ];
        }
        $this->port = $Port;
        $this->save();
        return [
            'ok' => true,
            'msg' => $this->port,
        ];
    }

    /**
     * User's next traffic reset time
     */
    public function validUseLoop(): string
    {
        $boughts = Bought::where('userid', $this->id)->orderBy('id', 'desc')->get();
        $data = [];
        foreach ($boughts as $bought) {
            $shop = $bought->shop();
            if ($shop !== null && $bought->valid()) {
                $data[] = $bought->resetTime();
            }
        }
        if (count($data) === 0) {
            return 'Package not purchased.';
        }
        if (count($data) === 1) {
            return $data[0];
        }
        return 'Multiple valid packages cannot be displayed.';
    }

    /**
     * Add recharge record when manually modifying user balance, limited by Config
     *
     * @param mixed $total amount
     */
    public function addMoneyLog($total): void
    {
        if ($_ENV['money_from_admin'] && $total !== 0.00) {
            $codeq = new Code();
            $codeq->code = ($total > 0 ? 'admin reward' : 'admin punishment');
            $codeq->isused = 1;
            $codeq->type = -1;
            $codeq->number = $total;
            $codeq->usedatetime = date('Y-m-d H:i:s');
            $codeq->userid = $this->id;
            $codeq->save();
        }
    }

    /**
     * Send Telegram message
     */
    public function sendTelegram(string $text): bool
    {
        $result = false;
        try {
            if ($this->telegram_id > 0) {
                Telegram::send(
                    $text,
                    $this->telegram_id
                );
                $result = true;
            }
        } catch (Exception $e) {
            echo $e->getMessage();
        }
        return $result;
    }

    /**
     * Send daily traffic reports
     *
     * @param string $ann announcement
     */
    public function sendDailyNotification(string $ann = ''): void
    {
        $lastday_traffic = $this->todayUsedTraffic();
        $enable_traffic = $this->enableTraffic();
        $used_traffic = $this->usedTraffic();
        $unused_traffic = $this->unusedTraffic();
        switch ($this->sendDailyMail) {
            case 0:
                return;
            case 1:
                echo 'Send daily mail to user: ' . $this->id;
                $this->sendMail(
                    $_ENV['appName'] . '-Daily traffic reports and announcements',
                    'news/daily-traffic-report.tpl',
                    [
                        'user' => $this,
                        'text' => 'The following is the latest announcement in the system:<br><br>' . $ann . '<br><br>Good night! ',
                        'lastday_traffic' => $lastday_traffic,
                        'enable_traffic' => $enable_traffic,
                        'used_traffic' => $used_traffic,
                        'unused_traffic' => $unused_traffic,
                    ],
                    [],
                    true
                );
                break;
            case 2:
                echo 'Send daily Telegram message to user: ' . $this->id;
                $text = date('Y-m-d') . 'Data Usage Report' . PHP_EOL . PHP_EOL;
                $text .= 'Traffic Total:' . $enable_traffic . PHP_EOL;
                $text .= 'Used Traffic:' . $used_traffic . PHP_EOL;
                $text .= 'Remaining traffic:' . $unused_traffic . PHP_EOL;
                $text .= 'Today\'s usage:' . $lastday_traffic;
                $this->sendTelegram(
                    $text
                );
                break;
        }
    }

    /**
     * Record login IP
     *
     * @param int $type login failure is 1
     */
    public function collectLoginIP(string $ip, int $type = 0): bool
    {
        $loginip = new LoginIp();
        $loginip->ip = $ip;
        $loginip->userid = $this->id;
        $loginip->datetime = \time();
        $loginip->type = $type;

        return $loginip->save();
    }
}
