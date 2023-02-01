<!DOCTYPE html>
<html lang="en-us">
<head>
    <meta charset="UTF-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" name="viewport">
    <meta name="theme-color" content="#4285f4">
    <title>{$config['appName']}</title>
    <!-- css -->
    <link href="/theme/tabler/css/base.min.css" rel="stylesheet">
    <link href="/theme/tabler/css/project.min.css" rel="stylesheet">
    <link href="/theme/tabler/css/user.min.css" rel="stylesheet">
    <link href="//cdn.jsdelivr.net/npm/@mdi/font@latest/css/materialdesignicons.min.css" rel="stylesheet">
    <!-- jquery -->
    <script src="//cdn.jsdelivr.net/npm/jquery/dist/jquery.min.js"></script>
    <!-- js -->
    <script src="/assets/js/fuck.min.js"></script>
    <script src="//cdn.jsdelivr.net/gh/davidshimjs/qrcodejs@master/qrcode.min.js"></script>
</head>
<body class="page-orange">
<header class="header header-orange header-transparent header-waterfall ui-header">
    <ul class="nav nav-list pull-left">
        <div>
            <a data-toggle="menu" href="#ui_menu">
                <span class="mdi mdi-menu icon-lg text-white"></span>
            </a>
        </div>
    </ul>
    <ul class="nav nav-list pull-right">
        <div class="dropdown margin-right">
            <a class="dropdown-toggle padding-left-no padding-right-no" data-toggle="dropdown">
                <span class="access-hide">{$user->user_name}</span>
                <span class="avatar avatar-sm"><img src="{$user->gravatar}"></span>
            </a>
            <ul class="dropdown-menu dropdown-menu-right">
                <li>
                    <a class="padding-right-cd waves-attach" href="/user/logout">
                        <span class="mdi mdi-exit-to-app icon-lg margin-right"></span>Logout
                    </a>
                </li>
            </ul>
        </div>
    </ul>
</header>
<nav aria-hidden="true" class="menu menu-left nav-drawer nav-drawer-md" id="ui_menu" tabindex="-1">
    <div class="menu-scroll">
        <div class="menu-content">
            <a class="menu-logo" href="/">&nbsp;{$config['appName']}</a>
            <ul class="nav">
                <li>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_me">Account</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_me">
                        <li>
                            <a href="/user"><i class="mdi mdi-home icon-lg"></i>&nbsp;User center</a>
                        </li>
                        <li>
                            <a href="/user/profile"><i class="mdi mdi-account-box icon-lg"></i>&nbsp;Account information</a>
                        </li>
                        <li>
                            <a href="/user/edit"><i class="mdi mdi-account-edit icon-lg"></i>&nbsp;Edit profile</a>
                        </li>
                        {if $config['subscribeLog']===true && $config['subscribeLog_show']===true}
                        <li>
                            <a href="/user/subscribe_log"><i class="mdi mdi-file-find icon-lg"></i>&nbsp;Subscription logs</a>
                        </li>
                        {/if}
                        {if $config['enable_ticket']===true}
                            <li>
                                <a href="/user/ticket"><i class="mdi mdi-comment-question icon-lg"></i>&nbsp;Ticketing</a>
                            </li>
                        {/if}
                        <li>
                            <a href="/user/invite"><i class="mdi mdi-account-multiple-plus icon-lg"></i>&nbsp;Invitation</a>
                        </li>
                    </ul>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_use">Use</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_use">
                        <li>
                            <a href="/user/server"><i class="mdi mdi-server icon-lg"></i>&nbsp;Servers</a>
                        </li>
                        <li>
                            <a href="/user/media"><i class="mdi mdi-multimedia icon-lg"></i>&nbsp;Media streaming</a>
                        </li>
                        <li>
                            <a href="/user/announcement"><i class="mdi mdi-bullhorn-variant icon-lg"></i>&nbsp;Announcement</a>
                        </li>
                        <li>
                            <a href="/user/detect"><i class="mdi mdi-account-filter icon-lg"></i>&nbsp;Auditing rules</a>
                        </li>
                        <li>
                            <a href="/user/detect/log"><i class="mdi mdi-calendar-filter icon-lg"></i>&nbsp;Audit logs</a>
                        </li>
                    </ul>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_help">Store</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_help">
                        <li>
                            <a href="/user/code"><i class="mdi mdi-wallet-plus icon-lg"></i>&nbsp;Charge balance</a>
                        </li>
                        <li>
                            <a href="/user/shop"><i class="mdi mdi-wallet-travel icon-lg"></i>&nbsp;Buy plan</a>
                        </li>
                        <li>
                            <a href="/user/bought"><i class="mdi mdi-list-box icon-lg"></i>&nbsp;Purchase records</a>
                        </li>
                    </ul>
                    {if $user->is_admin}
                        <a href="/admin"><i class="mdi mdi-account-tie icon-lg"></i>&nbsp;Admin</a>
                    {/if}
                    {if $can_backtoadmin}
                        <a href="/user/backtoadmin"><i class="mdi mdi-keyboard-return icon-lg"></i>&nbsp;Back to admin</a>
                    {/if}
                </li>
            </ul>
        </div>
    </div>
</nav>

{include file='live_chat.tpl'}