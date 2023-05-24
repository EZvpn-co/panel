<?php

//basic settings---------------------------------------------- ----------------------------------------------
$_ENV['key'] = 'EzVpNisBeSt'; //Please be sure to modify this key to a random string
$_ENV['pwdMethod'] = 'bcrypt'; // password encryption optional md5, sha256, bcrypt, argon2i, argon2id (argon2i requires at least php7.2)
$_ENV['salt'] = ''; //It is recommended to cooperate with md5/sha256, bcrypt/argon2i/argon2id will ignore this item

$_ENV['debug'] = false; //debug mode switch, please keep it as false in production environment
$_ENV['appName'] = 'EZvpn'; //site name
$_ENV['baseUrl'] = 'https://dashboard.ezvpn.co'; //site address
$_ENV['muKey'] = 'igU6fyUmkneTRbRgQ1Kw'; //WebAPI key, used for communication between node server and panel

//Database settings ---------------------------------------------- ----------------------------------------------
// Choose one of db_host|db_socket, if db_socket is set, db_host will be ignored, please leave it blank. If the database is on the local machine, it is recommended to use db_socket.
// db_host example: localhost (resolvable host name), 127.0.0.1 (IP address), 10.0.0.2:4406 (including port)
// db_socket example: /var/run/mysqld/mysqld.sock (absolute address is required)
$_ENV['db_driver']    = 'mysql';
$_ENV['db_host']      = '';
$_ENV['db_socket']    = '';
$_ENV['db_database']  = 'ezvpn_dashboard';           //数据库名
$_ENV['db_username']  = 'root';              //数据库用户名
$_ENV['db_password']  = 'rasoul707';           //用户名对应的密码
#高级
$_ENV['db_charset']   = 'utf8mb4';
$_ENV['db_collation'] = 'utf8mb4_unicode_ci';
$_ENV['db_prefix']    = '';

// Streaming media unlocking The following settings will enable nodes 397 and 297 to reuse the detection results of node 4 and remove the comment when using //
$_ENV['streaming_media_unlock_multiplexing'] = [
    //'397' => '4',
    //'297' => '4',
];


$_ENV['user_levels_name'] = [
    -1 => "NotActive",
    0 => "Free",
    1 => "Normal",
    2 => "VIP",
    3 => "Full"
];

$_ENV['user_groups_name'] = [
    0 => "Daily",
    1 => "Close Friends",
];

$_ENV['node_levels_name'] = [
    0 => "Public",
    1 => "Silver",
    2 => "Golden",
    3 => "Diamond",
];


//E-Mail settings---------------------------------------------- ----------------------------------------------
$_ENV['mail_filter'] = 0; //0: off; 1: whitelist mode; 2; blacklist mode;
$_ENV['mail_filter_list'] = array("qq.com", "vip.qq.com", "foxmail.com");

//Registered user settings -------------------------------------------- -----------------------------------------------
#Base
$_ENV['enable_checkin'] = true; //Whether to enable the checkin function
$_ENV['checkinMin'] = 1; //User check-in minimum traffic unit MB
$_ENV['checkinMax'] = 50; //User check-in maximum traffic

$_ENV['auto_clean_uncheck_days'] = -1; //How many days of automatic cleaning of level 0 users who have not checked in, when less than or equal to 0, close
$_ENV['auto_clean_unused_days'] = -1; //How many days of unused level 0 users are automatically cleaned up, closed when less than or equal to 0
$_ENV['auto_clean_min_money'] = 1; //Level 0 users whose balance is lower than the amount can be cleaned

$_ENV['enable_bought_reset'] = true; //Whether to reset traffic when buying
$_ENV['enable_bought_extend'] = true; // Whether to extend the level period when purchasing (same level package)

#advanced
$_ENV['class_expire_reset_traffic'] = 0; //Reset traffic value when class expires, unit GB, no reset when less than 0
$_ENV['account_expire_delete_days'] = -1; //The account will be deleted after a few days after the account expires, if it is less than 0, it will not be deleted

$_ENV['enable_kill'] = true; //Whether to allow users to log out of accounts
$_ENV['enable_change_email'] = true; //Whether to allow users to change account email

#Email reminder for insufficient user data allowance
$_ENV['notify_limit_mode'] = false; //false is closed, per is reminded by percentage, mb is reminded by fixed remaining traffic
$_ENV['notify_limit_value'] = 20; //When the previous item is per, fill in the percentage here; when the previous item is mb, fill in the traffic here

//log settings ---------------------------------------------- -----------------------------------------
$_ENV['trafficLog'] = true; //Whether to record the traffic used by users every hour
$_ENV['trafficLog_keep_days'] = 14; //The number of days to keep traffic records per hour

$_ENV['subscribeLog'] = true; //Whether to record user subscription log
$_ENV['subscribeLog_show'] = true; //Whether to allow users to view subscription records
$_ENV['subscribeLog_keep_days'] = 7; //Subscribe log retention days

// Subscription settings ------------------------------------------- -----------------------------------------
$_ENV['Subscribe'] = true; //Whether this site provides subscription function
$_ENV['subUrl'] = 'https://subscription.ezvpn.co'; //Subscription address, if it needs to be the same as the site name, please do not modify
$_ENV['enable_forced_replacement'] = true; //When the user modifies the account login password, whether to force the replacement of the subscription address


//Audit automatic ban settings ------------------------------------------ ------------------------------------------------
$_ENV['enable_auto_detect_ban'] = false; // Audit auto-ban switch
$_ENV['auto_detect_ban_numProcess'] = 300; // The number of audit records processed in a single scheduled task
$_ENV['auto_detect_ban_allow_admin'] = true; // Admins are not subject to audit restrictions
$_ENV['auto_detect_ban_allow_users'] = []; // Audit ban exception user IDs

// Audit ban judgment type:
// - 1 = merciful mode, ban every touch
// - 2 = Crazy mode, the cumulative number of touches will be banned for different durations according to the ladder
$_ENV['auto_detect_ban_type'] = 1;
$_ENV['auto_detect_ban_number'] = 30; // The number of triggers required for each ban in benevolent mode
$_ENV['auto_detect_ban_time'] = 60; // The duration of each ban in mercy mode (minutes)

// crazy mode ladder
// key is the number of triggers
// - type: optional time delete numbers by time or kill
// - time: time in minutes
$_ENV['auto_detect_ban'] = [
    100 => [
        'type' => 'time',
        'time' => 120
    ],
    300 => [
        'type' => 'time',
        'time' => 720
    ],
    600 => [
        'type' => 'time',
        'time' => 4320
    ],
    1000 => [
        'type' => 'kill',
        'time' => 0
    ]
];


//Bot settings ---------------------------------------------- ----------------------------------------------
#Telegram bot
$_ENV['enable_telegram'] = true; //Whether to enable Telegram bot
$_ENV['telegram_token'] = '5536109489:AAFHDYYw38_wTIsaU_MrPZxJj-EGTlIZ0KQ'; //Telegram bot, bot token, apply with father bot
$_ENV['telegram_chatid'] = -111; //Telegram bot, group session ID, you can get it by pulling the robot into the group and /ping him
$_ENV['telegram_bot'] = 'EZvpn_co_bot'; //Telegram robot account
$_ENV['telegram_group_quiet'] = false; //Telegram bot does not respond in groups
$_ENV['telegram_request_token'] = ''; //The Telegram robot requests the Key, which can be set at will, consisting of uppercase and lowercase English and numbers. After updating this parameter, please use php xcat Tool setTelegram

# General
$_ENV['finance_public'] = true; //Whether the financial report is open to the group
$_ENV['enable_welcome_message'] = true; //The robot sends a welcome message

# Telegram BOT Other options
$_ENV['allow_to_join_new_groups'] = true; //Allow Bot to join groups other than the configuration below
$_ENV['group_id_allowed_to_join'] = []; //Allowed to join group ID, the format is PHP array
$_ENV['telegram_admins'] = []; //Additional Telegram admin IDs in PHP array format
$_ENV['enable_not_admin_reply'] = true; //Whether the non-administrator operation administrator function should reply
$_ENV['not_admin_reply_msg'] = '!'; //Reply content of non-administrator operation administrator function
$_ENV['no_user_found'] = '!'; // When the administrator operates, the user's reply cannot be found
$_ENV['no_search_value_provided'] = '!'; // When the administrator operates, there is no reply to the user's search value
$_ENV['data_method_not_found'] = '!'; // When the administrator operates, the field to modify the data is not found.
$_ENV['delete_message_time'] = 180; //Delete bot responses triggered by user commands after the following time, unit: second, the deletion time may vary due to scheduled tasks, 0 means this function is not enabled
$_ENV['delete_admin_message_time'] = 86400; //Delete the bot reply triggered by the management command after the following time, unit: second, the deletion time may be different due to the scheduled task, 0 means this function is not enabled
$_ENV['enable_delete_user_cmd'] = false; //Automatically delete commands sent by users in the group, use the time configured by delete_message_time, the deletion time may vary due to scheduled tasks
$_ENV['help_any_command'] = false; //Allow any unknown command to trigger /help reply




$_ENV['remark_user_search_email']           = ['邮箱'];                     //用户搜索字段 email 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_search_port']            = ['端口'];                     //用户搜索字段 port 的别名，可多个，格式为 PHP 数组

$_ENV['remark_user_option_is_admin']        = ['管理员'];                   //用户搜索字段 is_admin 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_enable']          = ['用户启用'];                  //用户搜索字段 enable 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_money']           = ['金钱', '余额'];             //用户搜索字段 money 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_port']            = ['端口'];                     //用户搜索字段 port 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_transfer_enable'] = ['流量'];                     //用户搜索字段 transfer_enable 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_passwd']          = ['连接密码'];                 //用户搜索字段 passwd 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_method']          = ['加密'];                     //用户搜索字段 method 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_invite_num']      = ['邀请数量'];                 //用户搜索字段 invite_num 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_node_group']      = ['用户组', '用户分组'];       //用户搜索字段 node_group 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_class']           = ['等级'];                     //用户搜索字段 class 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_class_expire']    = ['等级过期时间'];             //用户搜索字段 class_expire 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_expire_in']       = ['账号过期时间'];             //用户搜索字段 expire_in 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_node_speedlimit'] = ['限速'];                    //用户搜索字段 node_speedlimit 的别名，可多个，格式为 PHP 数组
$_ENV['remark_user_option_node_connector']  = ['连接数', '客户端'];         //用户搜索字段 node_connector 的别名，可多个，格式为 PHP 数组

$_ENV['enable_user_email_group_show']       = false;                      //开启在群组搜寻用户信息时显示用户完整邮箱，关闭则会对邮箱中间内容打码，如 g****@gmail.com
$_ENV['user_not_bind_reply']                = '您未绑定本站账号，您可以进入网站的 **资料编辑**，在右下方绑定您的账号.';                      //未绑定账户的回复
$_ENV['telegram_general_pricing']           = '产品介绍.';                  //面向游客的产品介绍
$_ENV['telegram_general_terms']             = '服务条款.';                  //面向游客的服务条款

// social login settings
#Telegram
$_ENV['enable_telegram_login'] = true; //Please configure the Telegram bot before enabling this setting, otherwise it will not take effect

#Work order system settings
$_ENV['enable_ticket'] = true; //whether to enable ticket system
$_ENV['mail_ticket'] = true; //Whether to open ticket email reminder

# Server Sauce When a user submits a new work order or replies to a work order, use WeChat to remind the airport owner https://sct.ftqq.com/
$_ENV['useScFtqq'] = false; //Whether to enable work order Server sauce reminder
$_ENV['ScFtqq_SCKEY'] = ''; //Please fill in the SCKEY you got from the server, please check carefully and don't paste it wrong

#Backstage product list sales statistics
$_ENV['sales_period'] = 30; //Statistics of sales in the specified period, the value is [expire/any integer greater than 0]

// Node detection ---------------------------------------------- --------------------------------------------------
#GFW detection, please [enable/disable] through crontab
$_ENV['detect_gfw_interval'] = 3600; //Detection interval, unit: second, if it is lower than the recommended value, it will explode
$_ENV['detect_gfw_port'] = 22; //The TCP port opened by all node servers, commonly used is 22 (SSH port)
$_ENV['detect_gfw_url'] = 'http://cn-sh-tcping.sspanel.org:8080/tcping?ip={ip}&port={port}'; // API to detect whether the node is blocked by gfw the URL
$_ENV['detect_gfw_count'] = '3'; //Number of attempts

# Offline detection
$_ENV['enable_detect_offline'] = true;
#Offline detection whether to push to Server sauce Please configure the above Server configuration
$_ENV['enable_detect_offline_useScFtqq'] = false;

//All of the following are advanced settings (generally not used, no need to change -------------------------------- --------------------------------------

// Whether the main site provides WebAPI
// - For security, it is recommended to use the WebAPI mode to connect to the node and close the public network database connection.
// - Can be set to false if all your nodes use database connections or if you have a separate WebAPI site or gRPC API.
$_ENV['WebAPI'] = true;





#miscellaneous
$_ENV['authDriver'] = 'cookie'; //This cannot be changed
$_ENV['sessionDriver'] = 'cookie'; //Optional: cookie
$_ENV['cacheDriver'] = 'cookie'; //Optional: cookie
$_ENV['tokenDriver'] = 'db'; //Optional: db

$_ENV['enable_login_bind_ip'] = false; //Whether to bind the login thread and IP
$_ENV['rememberMeDuration'] = 7; //The number of days to remember the account when logging in

$_ENV['timeZone'] = 'PRC'; //PRC China time UTC Green time
$_ENV['theme'] = 'tabler'; //default theme
$_ENV['jump_delay'] = 1200; //Jump delay, unit ms, not recommended to be too long

$_ENV['checkNodeIp'] = true; //Whether webapi verifies node ip
$_ENV['muKeyList'] = []; //Multiple key list
$_ENV['keep_connect'] = false; // Speed limit to 1Mbps for traffic exhausted users
$_ENV['money_from_admin'] = true; //Whether to enable the administrator to create a recharge record when modifying the user balance

#Cloudflare
$_ENV['cloudflare_enable'] = false; // Whether to enable Cloudflare analysis
$_ENV['cloudflare_email'] = ''; //Cloudflare email address
$_ENV['cloudflare_key'] = ''; //Cloudflare API Key
$_ENV['cloudflare_name'] = ''; //domain name

#Whether to include statistical code, create an analytics.tpl under resources/views/{theme name}, use literal delimiter if necessary
$_ENV['enable_analytics_code'] = false;

#Get the user's real ip after setting up the CDN, if you don't know what it is, please don't mess around
$_ENV['cdn_forwarded_ip'] = array('HTTP_X_FORWARDED_FOR', 'HTTP_ALI_CDN_REAL_IP', 'X-Real-IP', 'True-Client-Ip');
foreach ($_ENV['cdn_forwarded_ip'] as $cdn_forwarded_ip) {
    if (isset($_SERVER[$cdn_forwarded_ip])) {
        $list = explode(',', $_SERVER[$cdn_forwarded_ip]);
        $_SERVER['REMOTE_ADDR'] = $list[0];
        break;
    }
}

// https://sentry.io for production debugging
$_ENV['sentry_dsn'] = '';

// The ClientDownload command resolves the restricted use of Github access tokens due to the high frequency of API access
$_ENV['github_access_token'] = '';

$_ENV['php_user_group'] = 'www:www';
