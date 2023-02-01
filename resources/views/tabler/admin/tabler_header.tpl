<!doctype html>
<html lang="en-us">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
    <meta name="format-detection" content="telephone=no" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>{$config['appName']}</title>
    <!-- CSS files -->
    <link href="//cdn.jsdelivr.net/npm/@tabler/core@latest/dist/css/tabler.min.css" rel="stylesheet" />
    <link href="//cdn.jsdelivr.net/npm/@tabler/icons@latest/iconfont/tabler-icons.min.css" rel="stylesheet" />
    <link href="//cdn.datatables.net/v/bs5/dt-1.13.1/datatables.min.css" rel="stylesheet" />
    <!-- JS files -->
    <script src="//cdn.jsdelivr.net/npm/qrcode_js@1.0.0/qrcode.min.js"></script>
    <script src="//cdn.jsdelivr.net/npm/clipboard@2.0.11/dist/clipboard.min.js"></script>
    <script src="//cdn.jsdelivr.net/npm/jquery/dist/jquery.min.js"></script>
    <script src="//cdn.datatables.net/v/bs5/dt-1.13.1/datatables.min.js"></script>
    <style>
        .home-subtitle {
            font-size: 14px;
        }

        .home-title {
            font-size: 36px;
        }
    </style>
</head>

{if $user->is_dark_mode}
<body class='theme-dark'>
{else}
<body>
{/if}
    <div class="page">
        <header class="navbar navbar-expand-md navbar-dark navbar-overlap d-print-none">
            <div class="container-xl" style="background-image: none;">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar-menu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <h1 class="navbar-brand navbar-brand-autodark d-none-navbar-horizontal pe-0 pe-md-3" style="filter: none;">
                    <img src="/images/ez-logo-round_96x96.png" height="65" alt="EZvpn" class="navbar-brand-image">
                </h1>
                <div class="navbar-nav flex-row order-md-last">
                    <div class="nav-item dropdown">
                        <a href="#" class="nav-link d-flex lh-1 text-reset p-0" data-bs-toggle="dropdown" aria-label="Open user menu">
                            <span class="avatar avatar-sm"
                                style="background-image: url({$user->gravatar})"></span>
                            <div class="d-none d-xl-block ps-2">
                                <div>{$user->email}</div>
                                <div class="mt-1 small text-muted">{$user->user_name}</div>
                            </div>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                            {if $user->is_dark_mode}
                            <a id="switch_theme_mode" class="dropdown-item">Light mode</a>
                            {else}
                            <a id="switch_theme_mode" class="dropdown-item">Dark mode</a>
                            {/if}
                            <a href="/user/logout" class="dropdown-item">Logout</a>
                        </div>
                    </div>
                </div>
                <div class="collapse navbar-collapse" id="navbar-menu">
                    <div class="d-flex flex-column flex-md-row flex-fill align-items-stretch align-items-md-center">
                        <ul class="navbar-nav">
                            <li class="nav-item">
                                <a class="nav-link" href="/admin">
                                    <span class="nav-link-icon d-md-none d-lg-inline-block">
                                        <i class="ti ti-home icon"></i>
                                    </span>
                                    <span class="nav-link-title">
                                        Home
                                    </span>
                                </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#navbar-base" data-bs-toggle="dropdown"
                                    data-bs-auto-close="outside" role="button" aria-expanded="false">
                                    <span class="nav-link-icon d-md-none d-lg-inline-block">
                                        <i class="ti ti-settings icon"></i>
                                    </span>
                                    <span class="nav-link-title">
                                        Management
                                    </span>
                                </a>
                                <div class="dropdown-menu">
                                    <div class="dropdown-menu-columns">
                                        <div class="dropdown-menu-column">
                                            <a class="dropdown-item" href="/admin/setting">
                                                <i class="ti ti-tool"></i>&nbsp;
                                                Settings
                                            </a>
                                            <a class="dropdown-item" href="/admin/user">
                                                <i class="ti ti-users"></i>&nbsp;
                                                Users
                                            </a>
                                            <a class="dropdown-item" href="/admin/node">
                                                <i class="ti ti-server-2"></i>&nbsp;
                                                Nodes
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                                    data-bs-auto-close="outside" role="button" aria-expanded="false">
                                    <span class="nav-link-icon d-md-none d-lg-inline-block">
                                        <i class="ti ti-brand-hipchat icon"></i>
                                    </span>
                                    <span class="nav-link-title">
                                        Operating
                                    </span>
                                </a>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="/admin/announcement">
                                        <i class="ti ti-speakerphone"></i>&nbsp;
                                        Announcement
                                    </a>
                                    <a class="dropdown-item" href="/admin/ticket">
                                        <i class="ti ti-messages"></i>&nbsp;
                                        Tickets
                                    </a>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                                    data-bs-auto-close="outside" role="button" aria-expanded="false">
                                    <span class="nav-link-icon d-md-none d-lg-inline-block">
                                        <i class="ti ti-address-book icon"></i>
                                    </span>
                                    <span class="nav-link-title">
                                        Logs
                                    </span>
                                </a>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="/admin/login">
                                        <i class="ti ti-login"></i>&nbsp;
                                        Login
                                    </a>
                                    <a class="dropdown-item" href="/admin/subscribe">
                                        <i class="ti ti-rss"></i>&nbsp;
                                        Subscription
                                    </a>
                                    <a class="dropdown-item" href="/admin/invite">
                                        <i class="ti ti-friends"></i>&nbsp;
                                        Invitation
                                    </a>
                                    <a class="dropdown-item" href="/admin/alive">
                                        <i class="ti ti-router"></i>&nbsp;
                                        Onlines
                                    </a>
                                    <a class="dropdown-item" href="/admin/trafficlog">
                                        <i class="ti ti-arrows-up-down"></i>&nbsp;
                                        Traffic usages
                                    </a>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                                    data-bs-auto-close="outside" role="button" aria-expanded="false">
                                    <span class="nav-link-icon d-md-none d-lg-inline-block">
                                        <i class="ti ti-shield-check icon"></i>
                                    </span>
                                    <span class="nav-link-title">
                                        Audit
                                    </span>
                                </a>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="/admin/detect">
                                        <i class="ti ti-barrier-block"></i>&nbsp;
                                        Rules
                                    </a>
                                    <a class="dropdown-item" href="/admin/detect/log">
                                        <i class="ti ti-notes"></i>&nbsp;
                                        Logs
                                    </a>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#navbar-layout" data-bs-toggle="dropdown"
                                    data-bs-auto-close="outside" role="button" aria-expanded="false">
                                    <span class="nav-link-icon d-md-none d-lg-inline-block">
                                        <i class="ti ti-coin icon"></i>
                                    </span>
                                    <span class="nav-link-title">
                                        Financial
                                    </span>
                                </a>
                                <div class="dropdown-menu">
                                    <div class="dropdown-menu-columns">
                                        <div class="dropdown-menu-column">
                                            <a class="dropdown-item" href="/admin/product">
                                                <i class="ti ti-list-details"></i>&nbsp;
                                                Products
                                            </a>
                                            <a class="dropdown-item" href="/admin/order">
                                                <i class="ti ti-receipt"></i>&nbsp;
                                                Orders
                                            </a>
                                            <a class="dropdown-item" href="/admin/invoice">
                                                <i class="ti ti-file-dollar"></i>&nbsp;
                                                Bills
                                            </a>
                                            <a class="dropdown-item" href="/admin/coupon">
                                                <i class="ti ti-ticket"></i>&nbsp;
                                                Off code
                                            </a>
                                            <a class="dropdown-item" href="/admin/giftcard">
                                                <i class="ti ti-gift"></i>&nbsp;
                                                Gift card
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/user">
                                    <span class="nav-link-icon d-md-none d-lg-inline-block">
                                        <i class="ti ti-arrow-back-up icon"></i>
                                    </span>
                                    <span class="nav-link-title">
                                        User center
                                    </span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
</header>