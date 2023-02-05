<?php

declare(strict_types=1);

namespace App\Utils;

final class Check
{
    public static function isEmailLegal($email)
    {
        $res = [];
        $res['ret'] = 0;

        if (!Tools::isEmail($email)) {
            $res['msg'] = 'Email is not standardized';
            return $res;
        }

        $mail_suffix = explode('@', $email)[1];
        $mail_filter_list = $_ENV['mail_filter_list'];
        $res['msg'] = 'We were unable to deliver mail to the domain ' . $mail_suffix . ', please replace the email address';

        switch ($_ENV['mail_filter']) {
            case 0:
                // 关闭
                $res['ret'] = 1;
                return $res;
            case 1:
                // 白名单
                if (\in_array($mail_suffix, $mail_filter_list)) {
                    $res['ret'] = 1;
                }
                return $res;
            case 2:
                // 黑名单
                if (!\in_array($mail_suffix, $mail_filter_list)) {
                    $res['ret'] = 1;
                }
                return $res;
            default:
                // 更新后未设置该选项
                $res['ret'] = 1;
                return $res;
        }
    }
}
